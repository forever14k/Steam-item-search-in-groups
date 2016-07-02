var magic_number = BigInteger("76561197960265728");

var steam = {
	appid: 570,
	contextid: 2
}
var backpacks = {};
var results = {};
var steamids = {};

if (typeof($.cookie('strInventoryLastContext')) == "undefined")
{
	$.cookie('strInventoryLastContext', steam.appid+'_'+steam.contextid, { expires: 7, path: '/' });
}
else
{
	settings = $.cookie('strInventoryLastContext').split('_');
	steam.appid = settings[0];
	steam.contextid = settings[1];
}
function StringContains(search_string,search_word) {
	search_string	= search_string.toLowerCase();
	search_word		= search_word.toLowerCase();
	if (search_string.indexOf(search_word) >= 0)
	{
		return true;
	}
	return false;
}
function ToSteam64(steam32) {
	return magic_number.add(steam32).toString();
}
rgb2hex = function(r,g,b){ //thanks @lrvick
    var bin = r << 16 | g << 8 | b;
    return (function(h){
        return new Array(7-h.length).join("0")+h
    })(bin.toString(16).toUpperCase())
}
function QuickRegex(regex,string,callback){
	match = string.match(regex);
	if (match != null)
	{
		callback(true,match[1]);
	}
	callback(false,'');
}
function CloneObject(original) {
	return $.extend(true, {}, original)
}
function capitaliseFirstLetter(string)
{
    return string.charAt(0).toUpperCase() + string.slice(1);
}
function SettingsChanged() {
	$('#backpackscontent .backpacks').empty();
	$('#backpackscontent #uifilters').empty();
	steam.appid = $('#appid').val();
	steam.contextid = $('#contextid').val();
	$.cookie('strInventoryLastContext', steam.appid+'_'+steam.contextid, { expires: 7, path: '/' });
	$('#load_inventories').removeClass('btn_blue_white_innerfade').removeClass('btn_darkblue_white_innerfade').addClass('btn_green_white_innerfade');
	$('#load_inventories span').text('Load inventories (0/0)');
	$('#search_selected').removeClass('btn_blue_white_innerfade').removeClass('btn_green_white_innerfade').addClass('btn_darkblue_white_innerfade');
	backpacks = {};
	results = {};
	steamids = {};
	UiFilters = CloneObject(UiFiltersClear);
}
function SortResult() {
	var online = [];
	var ingame = [];
	var offline = [];
	$('.backpack .user .member_block').each(function() {
		status = "offline";
		if ($(this).children('.member_block_content').hasClass('online')) { status = "online"; }
		if ($(this).children('.member_block_content').hasClass('in-game')) { status = "ingame"; }
		switch(status) {
			case "online":
				online.push($(this).parent().parent().clone());
				break;
			case "ingame":
				ingame.push($(this).parent().parent().clone());
				break;
			case "offline":
				offline.push($(this).parent().parent().clone());
				break;
		}
		$('#backpackscontent .backpacks').empty();
		$.each(online,function(id,node){	node.appendTo('#backpackscontent .backpacks'); });
		$.each(ingame,function(id,node){	node.appendTo('#backpackscontent .backpacks'); });
		$.each(offline,function(id,node){	node.appendTo('#backpackscontent .backpacks'); });
	});
	$('.backpack .items img').mouseover(function(){
		position = $(this).position();
		tooltip = $(this).attr('tooltip');
		$('.backpack_tooltip').empty().append(tooltip);
		$('.backpack_tooltip').css('top',position.top - 8);
		$('.backpack_tooltip').css('left',position.left + 85);
		if (tooltip.match(/left>\w+\sGem:|Rune:<\/div>/i) != null)
		{
			$('.backpack_tooltip .left').css('width',120);
		}
		tournament_info = $('.backpack_tooltip #bp_tournamen_info');
		if (tournament_info.length > 0)
		{
			tournament_info.css('width',$('.backpack_tooltip .left').width() + $('.backpack_tooltip .right').width());
		}
		if (($('.backpack_tooltip').outerWidth() + $('.backpack_tooltip').offset().left + 0.5 ) >= $(window).width())
		{
			$('.backpack_tooltip').css('left','-1000px');
			$('.backpack_tooltip').css('left',position.left - $('.backpack_tooltip').outerWidth() - 3);
		}
	}).mouseout(function(){
		$('.backpack_tooltip').empty().css('top','-1000px').css('left','-1000px');
	});
}
function ShowResult(account_id,item_uid,desc) {
	if (typeof(results[account_id]) == "undefined")
	{
		$('#backpackscontent .backpacks').append(
			'<div class=backpack account_id='+account_id+'>'+
				'<div class=user account_id='+account_id+'></div>'+
				'<div class=items account_id='+account_id+'></div>'+
			'</div>'
		);
		$('.member_block[data-miniprofile='+account_id+']').clone().appendTo('.user[account_id='+account_id+']');
		results[account_id] = {};
	}
	if (typeof(results[account_id][item_uid]) == "undefined")
	{
		item_tooltip = "";
		item_border = "";
		BuildTooltip(desc,function(tooltip,border){
			item_tooltip = tooltip;
			item_border = border;
		});
		$('.items[account_id='+account_id+']').append(
			'<a href="//steamcommunity.com/profiles/'+steamids[account_id]+'/inventory/#'+steam.appid+'_'+steam.contextid+'_'+item_uid+'" target="_blank">'+
				'<img '+item_tooltip+' '+item_border+' src="//steamcommunity-a.akamaihd.net/economy/image/'+desc.icon_url+'/73fx49f">'+
			'</a>'
		);
	}
}
function BuildTooltipStrange(descriptions,callback) {
	$.each(descriptions,function(id,description){
		if (description.color == "CF6A32")
		{
			callback(description.color,description.value);
		}
	});
}
function BuildTooltipTournament(descriptions,callback) {
	//desc_match = descriptions[descriptions.length-1].value.match(/width=240\sheight=108\ssrc=\"(.*)\">.*width=100\sheight=60\ssrc=\"(.*)\"><span.*width=100\sheight=60\ssrc=\"(.*)\"><\/center>.*<b>(.*)<\/b>.*#999999>(.*)<\/font.*#666666>MatchID:\s(\d+)<\/font>/i);
	description = "";
	tournament_info = descriptions[descriptions.length-1].value;
	desc_match = tournament_info.match(/<font color=#999999>(.*?)<\/font>/i);
	//// 1: tournament img, 2: radiant img, 3: dire img, 4: type, 5: event, 6: matchid
	if (desc_match != null)
	{
		description += '<div id=bp_tournamen_info style=\'border-top:1px solid #BFBFBF;padding-top:10px;margin-top:30px;\'><center>';
		teams_match = tournament_info.match(/<img\swidth=100\sheight=60\ssrc=\"(.*?)\">.*<img\swidth=100\sheight=60\ssrc=\"(.*?)\">/i);
		if (teams_match != null)
		{
			description += '<img height=47 src='+teams_match[1]+'> vs.';
			description += '<img height=47 src='+teams_match[2]+'>';
			description += '<div style=\'clear:both\'><div>';
		}
		//description += '<img height=47 src='+desc_match[1]+'>:&nbsp;&nbsp;';
		//description += '<img height=47 src='+desc_match[1]+'> vs.';
		//description += '<img height=47 src='+desc_match[2]+'>';
		description += ' '+desc_match[1]+'</center></div>';
		callback(description);
	}
}
function BuildTooltipGem(descriptions) {
	description = "";
	gems = descriptions[descriptions.length-1].value.match(/span\sstyle\=\"font\-size\:\s18px\;\scolor\:\srgb\((\d+),\s(\d+),\s(\d+)\)\"\>(.*?)\<\/span\>\<br\>\<span\sstyle\=\"font\-size\:\s12px\">(.*?)<\/span/ig);
	if (gems != null)
	{	$.each(gems,function(gem_id,gem){
			gem_match = gem.match(/span\sstyle\=\"font\-size\:\s18px\;\scolor\:\srgb\((\d+),\s(\d+),\s(\d+)\)\"\>(.*?)\<\/span\>\<br\>\<span\sstyle\=\"font\-size\:\s12px\">(.*?)<\/span/i);
			if (StringContains(gem_match[5],'Bloodstone'))
			{
				gem_match[5] = 'Bloodstone';
			}
			if (StringContains(gem_match[5],'Games Watched'))
			{
				times_watch = gem_match[5].match(/(\d+)/i);
				if (times_watch != null)
				{
					gem_match[5] = 'Games Watched';
					gem_match[4] = gem_match[4]+': '+times_watch[1];
				}
			}
			description += BuildTooltipRow(gem_match[5]+':',gem_match[4],false,rgb2hex(gem_match[1],gem_match[2],gem_match[3]));
		});
	}
	return description;
}
function BuildTooltipUnusual(descriptions,callback) {
	description = "";
	if ((steam.appid == 570) && (steam.contextid == 2))
	{
		description = BuildTooltipGem(descriptions);
	}
	else {
		$.each(descriptions,function(desc_id,desc){
			effect_match = desc.value.match(/Effect:\s(.*)/i);
			if (effect_match != null)
			{
				description = BuildTooltipRow('Effect:',effect_match[1]);
			}
		});
	}
	callback(description);
}
function BuildTooltipRow(left,right,notnewline,color) {
	row = "";
	if (typeof(notnewline) == "undefined")
	{
		notnewline = false;
	}
	if (!notnewline)
	{
		row += "<br>";
	}
	if (typeof(color) == "undefined")
	{
		row += '<div class=left>' + left + '</div><div class=right>' + right + '</div>';
	}
	else {
		row += '<div class=left>' + left + '</div><div class=right><span style=\'color:#' + color + '\'>' + right + '</span></div>';
	}
	return row;
}
function BuildTooltip(desc,callback) {
	var tooltip = "",border,tournament_info = "";
	tooltip += BuildTooltipRow('Name:',desc.name,true,desc.name_color);
	if ((steam.appid == 730) && (steam.contextid == 2)) {
		exterior_match = desc.market_name.match(/\((.*)\)/i);
		if (exterior_match != null)
		{
			tooltip += BuildTooltipRow('Exterior:',exterior_match[1]);
		}
		$.each(desc.tags,function(tag_id,tag){
			switch(tag.category) {
				case "Quality":
					tooltip += BuildTooltipRow(tag.category_name+':',tag.name,false,tag.color);
					switch(tag.internal_name) {
						case "tournament":
							border = tag.color;
						case "strange":
							border = tag.color;
							BuildTooltipStrange(desc.descriptions,function(color,modifier){
								tooltip += BuildTooltipRow(tag.name+':',modifier.replace(tag.name,''),false,color);
							});
							break;
					};
					break;
				case "Rarity":
					tooltip += BuildTooltipRow(tag.category_name+':',tag.name,false,tag.color);
					if (typeof(border) == "undefined")
					{
						border = tag.color;
					}
					break;
			}
		});
	}
	if (steam.appid == 753) {
		if (steam.contextid == 6)
		{
			$.each(desc.tags,function(tag_id,tag){
				switch(tag.category_name) {
					case "Game":
						tooltip += BuildTooltipRow(tag.category_name+':',tag.name);
						break;
					case "Rarity":
						tooltip += BuildTooltipRow(tag.category_name+':',tag.name);
						break;
				}
			});
			//tooltip += BuildTooltipRow('Game:',desc.tags[0].name)
		}
	}
	if (steam.appid == 440)
	{
		classes = "";
		level_match = desc.type.match(/Level\s(\d+)/i);
		if(level_match != null) {
			tooltip += BuildTooltipRow('Level:',level_match[1]);
		}
		$.each(desc.tags,function(tag_id,tag){
			switch(tag.category) {
				case "Quality":
					tooltip += BuildTooltipRow(tag.category + ':',tag.name,false,tag.color);
					border = tag.color;
					switch(tag.name) {
						case "Strange":
							tooltip += BuildTooltipRow('Modifer:',desc.type.replace(desc.name+' - ',''),false,tag.color);
							break;
						case "Unusual":
							BuildTooltipUnusual(desc.descriptions,function(description){
								tooltip += description;
							});
							break;
					}
					break;
				case "Class":
					classes += tag.name + ", ";
					break;
			}
		});
		if (classes.length > 0) {
			tooltip += BuildTooltipRow('Classes:',classes.substring(0, classes.length - 2));
		}
	}
	if (steam.appid == 570)
	{
		$.each(desc.tags,function(tag_id,tag){
		switch(tag.category) {
			case "Quality":
				tooltip += BuildTooltipRow(tag.category+':',tag.name,false,tag.color);
				switch(tag.name)
				{
					case "Cursed":
						border = tag.color;
						break;
					case "Ascendant":
						border = tag.color;
						tooltip += BuildTooltipGem(desc.descriptions);
						break;
					case "Strange":
						border = tag.color;
						BuildTooltipStrange(desc.descriptions,function(color,modifier){
							tooltip += BuildTooltipRow('Modifier:',modifier,false,color);
						});
						break;
					case "Inscribed":
						border = tag.color;
						tooltip += BuildTooltipGem(desc.descriptions);
						break;
					case "Tournament":
						border = tag.color;
						BuildTooltipTournament(desc.descriptions,function(description){
							tournament_info += '<br><br>' + description;
						});
						break;
					case "Heroic":
						border = tag.color;
						BuildTooltipTournament(desc.descriptions,function(description){
							tournament_info += description;
						});
						break;
					case "Unusual":
						BuildTooltipUnusual(desc.descriptions,function(description){
							tooltip += description;
						});
						border = tag.color;
						break;
				}
				break;
			case "Rarity":
				tooltip += BuildTooltipRow(tag.category+':',tag.name,false,tag.color);
				if (typeof(border) == "undefined")
				{
					border = tag.color;
				}
				break;
			}
		});
	}
	if (tournament_info.length > 0)
	{
		tooltip += tournament_info;
	}
	callback('tooltip="'+tooltip+'"','style="border:1px solid #'+border+';"');
}
debug_count = 1;
debug_i = 0;
debug = false;
var GetInventoryTimeout = 1;
var GetInventoryIncrement = 4300;
function GetInventory(node,account_id,steam_id,delay,callback) {
	var timeout = setTimeout(function(){
			$.ajax({
				blockNode: $(node),
				blockSteamId: steam_id,
				blockAccountId: account_id,
				url: "//steamcommunity.com/profiles/"+steam_id+"/inventory/json/"+steam.appid+"/"+steam.contextid+"/?l=english",
				success: function(data) {
					callback(this,data);
//					blocked = false;
				},
				error: function(response,textStatus,error){
//					if (response.status == 403 || response.status == 503)
//					{
//						delay = parseInt(delay);
//						if (delay == 0)
//						{
//							delay = 60000;
//						}
//						else {
//							delay = delay + 500;
//						}
//						if (!blocked)
//						{
//							blocked = true;
//							var interval = delay / 1000;
//							$('#load_inventories span').text('We will resume in ~1m. ('+invCurrent+'/'+invAll+')');
//						}
//						setTimeout(function(){
//							GetInventory(node,account_id,steam_id,delay,callback)
//						},delay);
//					}
				},
				dataType: "json"
			});
		},GetInventoryTimeout);
		GetInventoryTimeout = GetInventoryTimeout + GetInventoryIncrement;
		//console.log(steam_id,GetInventoryTimeout);
}
function GetAllInventoris() {
	invIds = $('.member_block');
	invCurrent	= 0;
	invAll		= invIds.length;
	UiFilters = CloneObject(UiFiltersClear);
	$('#load_inventories span').text('Load inventories ('+invCurrent+'/'+invAll+')');
	$('.member_block').css('background','none');
	$.each(invIds,function(){
		account_id	= $(this).attr('data-miniprofile');
		steam_id	= ToSteam64(account_id);
		GetInventory(this,account_id,steam_id,0,function(ajax,data){
			invCurrent++;
			$('#load_inventories span').text('Load inventories ('+invCurrent+'/'+invAll+')');
			backpacks[ajax.blockAccountId] = data;
			UpdateUiFilters(data); //startpoint for new filters
			steamids[ajax.blockAccountId] = ajax.blockSteamId;
			ajax.blockNode.css('background','#3a3a3a');
			ajax.blockNode.attr('inv_loaded','true');
			if (invCurrent == 1)
			{
				$('#load_inventories').removeClass('btn_green_white_innerfade').addClass('btn_blue_white_innerfade');
				$('#search_selected').removeClass('btn_darkblue_white_innerfade').addClass('btn_blue_white_innerfade');
				$('#appid').prop('disabled', true);
				$('#contextid').prop('disabled', true);
			}
			if (invCurrent == invAll) {
				$('#load_inventories').removeClass('btn_blue_white_innerfade').addClass('btn_darkblue_white_innerfade');
				$('#search_selected').removeClass('btn_blue_white_innerfade').addClass('btn_green_white_innerfade');
				$('#appid').prop('disabled', false);
				$('#contextid').prop('disabled', false);
			}
		});
//		$.ajax({
//			blockNode: $(this),
//			blockSteamId: steam_id,
//			blockAccountId: account_id,
//			url: "http://steamcommunity.com/profiles/"+steam_id+"/inventory/json/"+steam.appid+"/"+steam.contextid+"/?l=english",
//			success: function(data) {
//				invCurrent++;
//				$('#load_inventories span').text('Load inventories ('+invCurrent+'/'+invAll+')');
//				backpacks[this.blockAccountId] = data;
//				UpdateUiFilters(data); //startpoint for new filters
//				steamids[this.blockAccountId] = this.blockSteamId;
//				this.blockNode.css('background','#3a3a3a');
//				this.blockNode.attr('inv_loaded','true');
//				if (invCurrent == 1)
//				{
//					$('#load_inventories').removeClass('btn_green_white_innerfade').addClass('btn_blue_white_innerfade');
//					$('#search_selected').removeClass('btn_darkblue_white_innerfade').addClass('btn_blue_white_innerfade');
//					$('#appid').prop('disabled', true);
//					$('#contextid').prop('disabled', true);
//				}
//				if (invCurrent == invAll) {
//					$('#load_inventories').removeClass('btn_blue_white_innerfade').addClass('btn_darkblue_white_innerfade');
//					$('#search_selected').removeClass('btn_blue_white_innerfade').addClass('btn_green_white_innerfade');
//					$('#appid').prop('disabled', false);
//					$('#contextid').prop('disabled', false);
//				}
//			},
//			error: function(response,textStatus,error){
//				console.log('error',response.status);
//			},
//			dataType: "json"
//		});
		if (debug)
		{
			if (debug_i == debug_count)
			{
				return false;
			}
			else {
				debug_i++;
			}
		}
		//return false;
	});
	var timeout_seconds = (GetInventoryTimeout-1)/1000;
	var timeout_minutes = Math.floor(timeout_seconds/60);
		timeout_seconds = timeout_seconds - (timeout_minutes*60);
	console.log('Expected loading time %s minutes, %s seconds.',timeout_minutes,timeout_seconds);
}
//ShowUi();
ShowUiIfMemberPage();
//CheckAndShow();
function ShowUiIfMemberPage() {
	if (window.location.hash != '')
	{
		if (StringContains(window.location.hash,'#members'))
		{
			setInterval(CheckAndShow, 500);
		}
	}
	else {
		Path = window.location.pathname.split('/');
		PathLast = Path.pop();
		if (PathLast == '')
		{
			PathLast = Path.pop();
		}
		if (PathLast == "members")
		{
			setInterval(CheckAndShow, 500);
		}
	}
}
$('.group_tab').click(function(){
	if ($(this).attr('id') == "group_tab_members")
		{
			setInterval(CheckAndShow, 500);
		}
});
function CheckAndShow() {
	if (($('#memberList').length > 0) && ($('#backpackscontent:visible').length < 1))
	{
		ShowMembersUi();
	}
}
function ShowMembersUi() {
		//PagesMod();
		if ($('.backpack_tooltip').length < 1)
		{
		$('head').append(
		'<style>'+
			'#backpackscontent { margin-bottom:20px; }'+
			'.backpack { width:908px; margin-top:10px;overflow:hidden; }'+
			'.backpack .user { width:200px; float:left; }'+
			'.backpack .user .member_block { width:200px; float:left; }'+
			'.backpack .items { padding-left:9px;overflow:hidden; }'+
			'.backpack .items img { height:47px; margin:0px 0px 5px 5px}'+
			'.settingss { float:right; }'+
			'.backpack_tooltip { position:absolute; top:-1000px;left:-1000px; background:#3a3a3a;padding:10px;border:1px solid #BFBFBF;border-radius:3px;max-width:500px }'+
			'.backpack_tooltip .left { width:75px;float:left;overflow:hidden;}'+
			'.backpack_tooltip .right { float:left; }'+
			'.member_block { transition: background 500ms;}'+
			'.graytab_body_wrapper {width: 934px;margin: 0 auto;padding: 1px 1px 0 1px;border-top-left-radius: 3px;border-top-right-radius: 3px;background-color: #272728;background: -moz-linear-gradient(top, #4e4e4d 19px, #252526 45px);background: -webkit-gradient(linear, left top, left bottom, color-stop(19px,#4e4e4d), color-stop(45px,#252526));background: -webkit-linear-gradient(top, #4e4e4d 19px,#252526 45px);background: -o-linear-gradient(top, #4e4e4d 19px,#252526 45px);background: -ms-linear-gradient(top, #4e4e4d 19px,#252526 45px);background: linear-gradient(to bottom, #4e4e4d 19px,#252526 45px);filter: progid:DXImageTransform.Microsoft.gradient( startColorstr=\'#4e4e4d\', endColorstr=\'#252526\',GradientType=0 );	background-repeat: repeat-x;background-position: top;}'+
			'.graytab_body {background-color: #252526; background: -moz-linear-gradient(top, #4f4f4e 0, #252526 42px);background: -webkit-gradient(linear, left top, left bottom, color-stop(0,#4f4f4e), color-stop(42px,#252526));background: -webkit-linear-gradient(top, #4f4f4e 0,#252526 42px);background: -o-linear-gradient(top, #4f4f4e 0,#252526 42px);background: -ms-linear-gradient(top, #4f4f4e 0,#252526 42px);background: linear-gradient(to bottom, #4f4f4e 0,#252526 42px);filter: progid:DXImageTransform.Microsoft.gradient( startColorstr=\'#4f4f4e\', endColorstr=\'#252526\',GradientType=0 );	background-repeat: repeat-x;background-position: top;border-top-left-radius: 3px;border-top-right-radius: 3px;padding: 24px 13px;}'+
			'.item_name { width:250px; }.filters {line-height:13px;font-size:10px;padding:3px;color:white;border-radius:2px;background: linear-gradient(to bottom, #8bb006 5%,#6b8805 95%);display:inline-block;}.uifilters {width:586px;}.uifilters_selectors,.ui_left,.ui_right {display:inline-block;}.ui_left {text-align:right;padding-right:7px;}.uifilters_selectors {vertical-align: top;margin-left:10px;margin-bottom:20px; }.ui_left {width:60px;}.ui_filter {display:block;margin-top:10px;}.uifilters select {width:200px;} '+
			'.select2-search-choice-close {background: url('+chrome.extension.getURL("select/select2.png")+') right top no-repeat;}.select2-container .select2-choice abbr { background: url('+chrome.extension.getURL("select/select2.png")+') right top no-repeat;}.select2-container .select2-choice .select2-arrow b {background: url('+chrome.extension.getURL("select/select2.png")+') no-repeat 0 1px;}.select2-search input {background: #fff url('+chrome.extension.getURL("select/select2.png")+') no-repeat 100% -22px; background: url('+chrome.extension.getURL("select/select2.png")+') no-repeat 100% -22px, -webkit-gradient(linear, left bottom, left top, color-stop(0.85, #fff), color-stop(0.99, #eee));  background: url('+chrome.extension.getURL("select/select2.png")+') no-repeat 100% -22px, -webkit-linear-gradient(center bottom, #fff 85%, #eee 99%);background: url('+chrome.extension.getURL("select/select2.png")+') no-repeat 100% -22px, -moz-linear-gradient(center bottom, #fff 85%, #eee 99%); background: url('+chrome.extension.getURL("select/select2.png")+') no-repeat 100% -22px, linear-gradient(top, #fff 85%, #eee 99%);  }.select2-search input.select2-active { background: #fff url('+chrome.extension.getURL("select/select2-spinner.gif")+') no-repeat 100%; background: url('+chrome.extension.getURL("select/select2-spinner.gif")+') no-repeat 100%, -webkit-gradient(linear, left bottom, left top, color-stop(0.85, #fff), color-stop(0.99, #eee));background: url('+chrome.extension.getURL("select/select2-spinner.gif")+') no-repeat 100%, -webkit-linear-gradient(center bottom, #fff 85%, #eee 99%); background: url('+chrome.extension.getURL("select/select2-spinner.gif")+') no-repeat 100%, -moz-linear-gradient(center bottom, #fff 85%, #eee 99%);background: url('+chrome.extension.getURL("select/select2-spinner.gif")+') no-repeat 100%, linear-gradient(top, #fff 85%, #eee 99%);}.select2-more-results.select2-active { background: #f4f4f4 url('+chrome.extension.getURL("select/select2-spinner.gif")+') no-repeat 100%;}.select2-container-multi .select2-choices .select2-search-field input.select2-active { background: #fff url('+chrome.extension.getURL("select/select2-spinner.gif")+') no-repeat 100% !important;}'+
		'</style>'
		);
			$('body').append('<div class=backpack_tooltip></div>');
		}
		$('.rightcol').after('<div style="clear: both;"></div><div class="graytab_body_wrapper"><div class="graytab_body" id=backpackscontent></div></div>');
		$('#backpackscontent').append(
			'<div class=settings>'+
				'<div class="gray_bevel for_text_input"><input size="40" class="" name="search_string" id="backpack_search" placeholder="Enter name of items you searching" value=""></div>'+
				'<div class="gray_bevel for_text_input" style="margin-left:10px;">Appid: <input size="4" class="" name="search_string" id="appid" placeholder="Appid" value="'+steam.appid+'"></div>'+
				'<div class="gray_bevel for_text_input" style="margin-left:10px;">Context: <input size="4" class="" name="search_string" id="contextid" placeholder="Context" value="'+steam.contextid+'"></div>'+
				'<button type="submit" id=search_selected class="btn_darkblue_white_innerfade btn_medium"  style="margin-left:10px;"><span>Search</span></button>'+
				'<button type="submit" id=load_inventories class="btn_green_white_innerfade btn_medium"  style="margin-left:10px;"><span>Load inventories (0/0)</span></button>'+
				'<div class=uifilters id=uifilters></div>'+
			'</div><div class=backpacks></div>'
		);
		$('#load_inventories').click(function(){
			GetAllInventoris();
		});
		$('#search_selected').click(function(){
			$('#backpackscontent .backpacks').empty();
			results = {};
			$.each(backpacks,function(account_id,backpack){
				if (backpack.success == true) {
					$.each(backpack.rgInventory,function(item_uid,item) {
						desc = backpack.rgDescriptions[item.classid+'_'+item.instanceid];
						if (Filter(desc))
						{
							ShowResult(account_id,item_uid,desc);
						}
					});
				}
			});
			SortResult();
		});
		$('#appid').change(function(){
			SettingsChanged()
		});
		$('#contextid').change(function(){
			SettingsChanged()
		});

}
UiFilters = {
	names: {
		quality:	[],
		rarity:		[],
		hero:		[],
		type:		[],
		game:		[],
		category:	[],
		exterior:	[],
		collection:	[],
		class:		[],
		slot: []
	},
	tags: {
		quality:	[],
		rarity:		[],
		hero:		[],
		type:		[],
		game:		[],
		category:	[],
		exterior:	[],
		collection: [],
		class:		[],
		slot: []
	},
	counts: {
		quality:	0,
		rarity:		0,
		hero:		0,
		type:		0,
		game:		0,
		category:	0,
		exterior:	0,
		collection: 0,
		class:		0,
		slot: 0
	},
	select: {
		quality:	1,
		rarity:		1,
		hero:		1,
		type:		1,
		game:		1,
		category:	1,
		exterior:	1,
		collection: 1,
		class:		1,
		slot: 1
	},
	can: {
		quality:	[],
		rarity:		[],
		hero:		[],
		type:		[],
		game:		[],
		category:	[],
		exterior:	[],
		collection: [],
		class:		[],
		slot: []
	}
};
UiFiltersClear = CloneObject(UiFilters);
function FillUiFilters() { //ui builder for filters
	var ui = $('#uifilters:visible');
	$.each(UiFilters.tags,function(filter_name,tags){
		if (tags.length > 0)
		{
			if ($('#uifilters_'+filter_name+':visible').length == 0)
			{
				ui.append('<div id="uifilters_'+filter_name+'" class="uifilters_selectors"></div>');
				$('#uifilters_'+filter_name).append('<div class=ui_filter><div class=ui_left>'+capitaliseFirstLetter(filter_name)+': </div><div class=ui_right><input id="select_'+filter_name+'_0" data-filter='+filter_name+' style="width:200px;"></div></div>');
				MakeSelect2($('#select_'+filter_name+'_0'));
			}
		}
	});
}
function Select2FormatResult(item) {
	if (item.havecolor)
	{
		return '<div style="width:15px;height:15px;background:#'+item.color+';float:left;border-radius:5px;margin-right:5px;"></div> '+item.text;
	}
	else {
		return item.text;
	}
}
function Select2FormatSelection(item) {
	if (item.havecolor)
	{
		return '<div style="width:15px;height:15px;background:#'+item.color+';float:left;border-radius:5px;margin-right:5px;margin-top:5px;"></div> '+item.text;
	}
	else {
		return item.text;
	}
}
function Filter(desc) {
	input = $('#backpack_search').val();
	filters = {};
	var accept = false;
	//////
	//////
	if ((typeof(desc.tags) != "undefined"))
	{
		$.each(desc.tags,function(tag_id,tag){
			switch(tag.category_name) {
				case "Rarity":
					if (UiFilters.can.rarity.length > 0)
					{
						filters.rarity = false;
						if ($.inArray(tag.name,UiFilters.can.rarity) > -1) {
							filters.rarity = true;
						}
					}
					break;
				case "Quality":
					if (UiFilters.can.quality.length > 0)
					{
						filters.quality = false;
						if ($.inArray(tag.name,UiFilters.can.quality) > -1) {
							filters.quality = true;
						}
					}
					break;
				case "Hero":
					if (UiFilters.can.hero.length > 0)
					{
						filters.hero = false;
						if ($.inArray(tag.name,UiFilters.can.hero) > -1) {
							filters.hero = true;
						}
					}
					break;
				case "Type":
					if (tag.category == "Type")
					{
						if (UiFilters.can.type.length > 0)
						{
							filters.type = false;
							if ($.inArray(tag.name,UiFilters.can.type) > -1) {
								filters.type = true;
							}
						}
					}
					if (tag.category == "Slot")
					{
						if (UiFilters.can.slot.length > 0)
						{
							filters.slot = false;
							if ($.inArray(tag.name,UiFilters.can.slot) > -1) {
								filters.slot = true;
							}
						}
					}
					break;
				case "Slot":
					if (tag.category == "Slot")
					{
						if (UiFilters.can.slot.length > 0)
						{
							filters.slot = false;
							if ($.inArray(tag.name,UiFilters.can.slot) > -1) {
								filters.slot = true;
							}
						}
					}
					break;
				case "Game":
					if (UiFilters.can.game.length > 0)
					{
						filters.game = false;
						if ($.inArray(tag.name,UiFilters.can.game) > -1) {
							filters.game = true;
						}
					}
					break;
				case "Category":
					if (UiFilters.can.category.length > 0)
					{
						filters.category = false;
						if ($.inArray(tag.name,UiFilters.can.category) > -1) {
							filters.category = true;
						}
					}
					break;
				case "Class":
					if (UiFilters.can.class.length > 0)
					{
						filters.class = false;
						if ($.inArray(tag.name,UiFilters.can.class) > -1) {
							filters.class = true;
						}
					}
					break;
			}
		});
	}
	if (typeof(desc.descriptions) != 'undefined')
		{
		if (UiFilters.can.exterior.length > 0)
		{
			filters.haveexterior = false;
		}
		if (UiFilters.can.collection.length > 0)
		{
			filters.havecollection = false;
		}
		$.each(desc.descriptions,function(description_id,decription_entry){
			if (UiFilters.can.exterior.length > 0)
			{
				QuickRegex(/Exterior: (.*)/i,decription_entry.value,function(success,result){
					if (success)
					{
						filters.haveexterior = true;
						filters.exterior = false;
						if ($.inArray(result,UiFilters.can.exterior) > -1) {
							filters.exterior = true;
						}
					}
				});
			}
			if (UiFilters.can.collection.length > 0)
			{
				if (typeof(decription_entry.app_data) != 'undefined')
				{
					filters.havecollection = true;
					filters.collection = false;
					if ($.inArray(decription_entry.value,UiFilters.can.collection) > -1) {
						filters.collection = true;
					}

				}
			}
		});
	}
	filters.havedescription = false;
	if (desc.market_name != undefined) {
			filters.havedescription = true;
	}
	/////
	filters.string = StringContains(desc.name,input);
	$.each(filters,function(id,key){
		if (key != true){
			accept = false;
			return false;
		}
		else {
			accept = true;
		}
	});
	return accept;
}
function UpdateUiFilters(data) { //fill up main array with possible filters
	if (data.success != true)
	{
		return;
	}
	$.each(data.rgDescriptions,function(description_id,description){
		if (typeof(description.tags) != 'undefined')
		{
			$.each(description.tags,function(tag_id,tag){
				if (tag.category_name == "Rarity")
				{
					if ($.inArray(tag.name,UiFilters.names.rarity) == -1) {
						UiFilters.names.rarity.push(tag.name);
						UiFilters.tags.rarity.push(tag);
					}
				}
				if (tag.category_name == "Quality")
				{
					if ($.inArray(tag.name,UiFilters.names.quality) == -1) {
						UiFilters.names.quality.push(tag.name);
						UiFilters.tags.quality.push(tag);
					}
				}
				if (tag.category_name == "Hero")
				{
					if ($.inArray(tag.name,UiFilters.names.hero) == -1) {
						UiFilters.names.hero.push(tag.name);
						UiFilters.tags.hero.push(tag);
					}
				}
				if (tag.category_name == "Type")
				{
					if (tag.category == "Type")
					{
						if ($.inArray(tag.name,UiFilters.names.type) == -1) {
							UiFilters.names.type.push(tag.name);
							UiFilters.tags.type.push(tag);
						}
					}
					if (tag.category == "Slot")
					{
						if ($.inArray(tag.name,UiFilters.names.slot) == -1) {
							UiFilters.names.slot.push(tag.name);
							UiFilters.tags.slot.push(tag);
						}
					}
				}
				if (tag.category_name == "Slot")
				{
					if ($.inArray(tag.name,UiFilters.names.slot) == -1) {
						UiFilters.names.slot.push(tag.name);
						UiFilters.tags.slot.push(tag);
					}
				}
				if (tag.category_name == "Game")
				{
					if ($.inArray(tag.name,UiFilters.names.game) == -1) {
						UiFilters.names.game.push(tag.name);
						UiFilters.tags.game.push(tag);
					}
				}
				if (tag.category_name == "Category")
				{
					if ($.inArray(tag.name,UiFilters.names.category) == -1) {
						UiFilters.names.category.push(tag.name);
						UiFilters.tags.category.push(tag);
					}
				}
				if (tag.category_name == "Class")
				{
					if ($.inArray(tag.name,UiFilters.names.class) == -1) {
						UiFilters.names.class.push(tag.name);
						UiFilters.tags.class.push(tag);
					}
				}
			});
		}
		if (typeof(description.descriptions) != 'undefined')
		{
			$.each(description.descriptions,function(description_id,decription_entry){
				QuickRegex(/Exterior: (.*)/i,decription_entry.value,function(success,result){
					if (success)
					{
						if ($.inArray(result,UiFilters.names.exterior) == -1) {
							UiFilters.names.exterior.push(result);
							UiFilters.tags.exterior.push({name:result});
						}
					}
				});
				if (typeof(decription_entry.app_data) != 'undefined')
				{
					if (StringContains(decription_entry.value,'Collection'))
					{
						if ($.inArray(decription_entry.value,UiFilters.names.collection) == -1) {
							UiFilters.names.collection.push(decription_entry.value);
							UiFilters.tags.collection.push({name:decription_entry.value});
						}
					}
				}
			});
		}
	});
	FillUiFilters();
}
setInterval(CheckUiFilters, 500);
function CheckUiFilters(){
	$.each(UiFilters.can,function(filter){
		UiFilters.can[filter] = [];
	});
	$('[id^=select_]').each(function(element_id,element){
		element = $(element);
		id = element.attr('id');
		filter = element.attr('data-filter');
		input = $('#'+id);
		data = input.select2('data');
		////
		if (data != null)
		{
			UiFilters.counts[filter] = 1;
			UiFiltersAddToCan(data,filter);
		}
		else {
			UiFilters.counts[filter] = 0;
		}
	});
	$.each(UiFilters.counts,function (filter,count) {
		if (count > 0)
		{
			UiFilters.select[filter]++;
			$('#uifilters_'+filter).append('<div class=ui_filter><div class=ui_left></div><div class=ui_right><input id="select_'+filter+'_'+UiFilters.select[filter]+'" data-filter='+filter+' style="width:200px;"></div></div>');
			MakeSelect2('#select_'+filter+'_'+UiFilters.select[filter]+'');
			UiFilters.counts[filter] = 0;
		}
	});
}
function UiFiltersAddToCan(data,filter) {
	if ($.inArray(data.text,UiFilters.can[filter]) == -1) {
		UiFilters.can[filter].push(data.text);
	}
};
function MakeSelect2(selector) {
	$(selector).select2({
		allowClear: true,
		placeholder: "Any",
		formatResult: Select2FormatResult,
		formatSelection: Select2FormatSelection,
		query:function(query){
			var data = {results: []};
			QueryFilter = query.element.attr('data-filter');
			$.each(UiFilters.tags[QueryFilter],function(tag_id,tag){
			if (StringContains(tag.name,query.term))
				{
				if ($.inArray(tag.name,UiFilters.can[QueryFilter]) == -1)
					{
						choise_color = "";
						havecolor = false;
						if (typeof(tag.color) != 'undefined')
						{
							havecolor = true;
							choise_color  = tag.color;
						}
						data.results.push({id: tag_id, text:tag.name, havecolor:havecolor, color:choise_color});
					}
				}
			});
			query.callback(data);
		}
	}).on("select2-removed",function (e){
		target = $(e.target);
		parent = target.parent().parent();
		CurrentFilter = target.attr('data-filter');
		if (parent.index() == 0)
		{
			$('#uifilters_'+CurrentFilter+' .ui_filter:nth-child(2) .ui_left').text(capitaliseFirstLetter(CurrentFilter)+': ');
		}
		target.select2("destroy");
		parent.remove();
	});
}
