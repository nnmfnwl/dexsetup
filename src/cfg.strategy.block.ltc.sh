cc_setup_helper_version="20210827"

cc_dexbot_naming_suffix_default="default"
cc_ticker_maker="BLOCK"
cc_ticker_taker="LTC"

cc_address_funds_only="True"

cc_address_maker_default="{cc_address_maker}"
cc_address_taker_default="{cc_address_taker}"

cc_sell_size_asset="BLOCK"
# opposite strategy using "*_opposite" variables if exist
cc_sell_size_asset_opposite="BLOCK"

# automatic maker price gathering
cc_maker_price=0.035
cc_maker_price_asset=USDT
cc_price_source_argval="--usecg"

# flush all canceled orders every 60 seconds
cc_flush_canceled_orders=60

# first placed orders
cc_sell_start_spread="2.1"
cc_sell_start_spread_opposite="2.1"
cc_sell_start="10"
cc_sell_start_min="6"
# last palced order
cc_sell_end_spread="1.04"
cc_sell_end_spread_opposite="1.04"
cc_sell_end="10"
cc_sell_end_min="6"

#~ cc_max_open_orders="{cc_max_open_orders}"
cc_max_open_orders="4"

cc_make_next_on_hit="False"
cc_partial_orders="False"

cc_reopen_finished_num=2
cc_reopen_finished_delay=300

cc_reset_on_price_change_positive=0.01
cc_reset_on_price_change_negative=0.05

cc_reset_after_delay=600
cc_reset_after_order_finish_number=3
cc_reset_after_order_finish_delay=0

cc_boundary_asset_argval=" "
cc_boundary_asset_track_argval=" "
cc_boundary_reversed_pricing_argval=" "
cc_boundary_start_price_argval=" "
cc_boundary_max_argval=" "
cc_boundary_min_argval=" "

#~ cc_boundary_asset_argval="--boundary_asset USDT"
#~ cc_boundary_start_price_argval="--boundary_start_price 1"
cc_boundary_max_argval="--boundary_max_relative 1.5"
cc_boundary_min_argval="--boundary_min_relative 0.99"

#~ cc_boundary_asset_argval="--boundary_asset USDT"
#~ cc_boundary_asset_track_argval="--boundary_asset_track True"
#~ cc_boundary_reversed_pricing_argval="--boundary_reversed_pricing False"
#~ cc_boundary_reversed_pricing_argval_opposite="--boundary_reversed_pricing True"
#~ cc_boundary_max_argval="--boundary_max_static 1.5"
#~ cc_boundary_min_argval="--boundary_min_static 0.95"

# automatic order maching 0 disabled, otherwise seconds to check
cc_takerbot="0"

cc_slide_dyn_asset=${cc_sell_size_asset}
cc_slide_dyn_asset_opposite=${cc_sell_size_asset_opposite}
cc_slide_dyn_asset_track="False"
cc_slide_dyn_zero_type="static"
cc_slide_dyn_zero="-2"
cc_slide_dyn_type="static"

# for better understanding of below dynamic slide parameters this, here simple example:

# lets say BLOCK/LTC DX BOT started first time with balance 100 BLOCK
# so orders would be created first order at cc_sell_start_spread
#                               1.order 10 (2.1 * actual price)
#                            second order must be spaced equally > compute from parameters > (2.1-(((2.1-1.04)/(2+1))x1)) = 1.746666667
#                               2.order 10 (1.746666667 * actual price) >> 
#                            third order must be space equally > compute from parameters > (2.1-(((2.1-1.04)/(2+1))x2)) = 1.393333333
#                               3.order 10 (1.393333333 * actual price)
#                            last order at cc_sell_end_spread
#                               4.order 10 (1.04 * actual price)

# lets say 5 of 100 BLOCK has been sold by bot, but cc_slide_dyn_sell_threshold = cc_sell_end_min = 6
#    so 5 < 6 so nothing has changed orders stay created before

# lets say 7 of 100 BLOCK sold, so 7/6 = 1.16
#    so all orders would be updated from
#       > 1.order 10 (2.10 * actual price)
#       > 4.order 10 (1.04 * actual price)
#    to this style
#       > 1.order 10 ((2.10 + (0.02)) * actual price)
#       > 4.order 10 ((1.04 + (0.02)) * actual price)

# lets sat 18 of 100 BLOCK sold, so 18/6 = 3
#    so all orders would be updated from
#       > 1.order 10 (2.10 * actual price)
#       > 4.order 10 (1.04 * actual price)
#    to this exponential style by stacking steps
#       > 1.order 10 ((2.10 + (0.02 + 0.02*1.3 + 0.02*1.3*1.3) * actual price)
#       > 4.order 10 ((1.04 + (0.02 + 0.02*1.3 + 0.02*1.3*1.3) * actual price)

cc_slide_dyn_sell_ignore=0
cc_slide_dyn_sell_threshold=${cc_sell_end_min}
cc_slide_dyn_sell_step=0.02
cc_slide_dyn_sell_step_multiplier=1.3
cc_slide_dyn_sell_max=4

cc_slide_dyn_buy_ignore=0
cc_slide_dyn_buy_threshold=${cc_sell_end_min}
cc_slide_dyn_buy_step=0.005
cc_slide_dyn_buy_step_multiplier=1.5
cc_slide_dyn_buy_max=3

cc_balance_save_number=0
cc_balance_save_percent=0

cc_im_really_sure_what_im_doing_argval=" "
cc_im_really_sure_what_im_doing_argval="--imreallysurewhatimdoing 0"

# include default help for variables that will be loaded when not already set
source "$(dirname "${BASH_SOURCE[0]}")/cfg.strategy.default_help.sh" || exit 1
