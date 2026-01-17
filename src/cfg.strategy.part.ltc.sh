cc_setup_helper_version="20210827"

cc_dexbot_naming_suffix_default="default"
cc_ticker_maker="PART"
cc_ticker_taker="LTC"

cc_address_funds_only="True"

cc_address_maker_default="{cc_address_maker}"
cc_address_taker_default="{cc_address_taker}"

cc_sell_size_asset="USDT"
# opposite strategy using "*_opposite" variables if exist
cc_sell_size_asset_opposite="USDT"

# automatic maker price gathering
cc_price_redirections=' '
cc_maker_price=0
cc_price_provider="cg"
cc_price_acceptable_outage=0
cc_price_outage_extra_slide=1.5

# flush all canceled orders every 60 seconds
cc_flush_canceled_orders=60

# first placed orders
cc_sell_start_spread="2.01"
cc_sell_start_spread_opposite="2.01"
cc_sell_start="10"
cc_sell_start_min="5"
# last palced order
cc_sell_end_spread="1.05"
#~ cc_sell_end_spread_opposite="1.05"
cc_sell_end="10"
cc_sell_end_min="5"

cc_max_open_orders="2"

cc_make_next_on_hit="False"
cc_partial_orders="False"

cc_reopen_finished_num=1
cc_reopen_finished_delay=300

cc_reset_on_price_change_positive=0.01
cc_reset_on_price_change_negative=0.05

cc_reset_after_delay=600
cc_reset_after_order_finish_number=3
cc_reset_after_order_finish_delay=0

cc_sboundary_asset="''"
cc_sboundary_max=0
cc_sboundary_min=0
cc_sboundary_max_track_asset="False"
cc_sboundary_min_track_asset="False"
cc_sboundary_price_reverse="False"
cc_sboundary_price_reverse_opposite="True"
cc_sboundary_max_cancel="True"
cc_sboundary_max_exit="True"
cc_sboundary_min_cancel="False"
cc_sboundary_min_exit="False"

cc_rboundary_asset="''"
cc_rboundary_price_initial=0
cc_rboundary_max="1.5"
cc_rboundary_min="0.9"
cc_rboundary_max_track_asset="False"
cc_rboundary_min_track_asset="False"
cc_rboundary_price_reverse="False"
cc_rboundary_max_cancel="True"
cc_rboundary_max_exit="True"
cc_rboundary_min_cancel="True"
cc_rboundary_min_exit="False"

cc_takerbot="0"

cc_slide_dyn_asset=${cc_sell_size_asset}
cc_slide_dyn_asset_opposite=${cc_sell_size_asset_opposite}
cc_slide_dyn_asset_track="False"
cc_slide_dyn_zero_type="static"
cc_slide_dyn_zero="-2"
cc_slide_dyn_type="static"

cc_slide_dyn_sell_ignore=0
cc_slide_dyn_sell_threshold=${cc_sell_end_min}
cc_slide_dyn_sell_step=0.03
cc_slide_dyn_sell_step_multiplier=1.5
cc_slide_dyn_sell_max=0

cc_slide_dyn_buy_ignore=0
cc_slide_dyn_buy_threshold=${cc_sell_end_min}
cc_slide_dyn_buy_step=0.01
cc_slide_dyn_buy_step_multiplier=1.5
cc_slide_dyn_buy_max=0.10

cc_balance_save_number=0
cc_balance_save_percent=0

cc_im_really_sure_what_im_doing_argval=" "
cc_im_really_sure_what_im_doing_argval="--imreallysurewhatimdoing 0"

# include default help for variables that will be loaded when not already set
source "$(dirname "${BASH_SOURCE[0]}")/cfg.strategy.default_help.sh" || exit 1
