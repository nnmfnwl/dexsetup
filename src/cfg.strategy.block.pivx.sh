cc_setup_helper_version="20210827"

cc_dexbot_naming_suffix_default="default"
cc_ticker_maker="BLOCK"
cc_ticker_taker="PIVX"

cc_address_funds_only="True"

cc_address_maker_default="{cc_address_maker}"
cc_address_taker_default="{cc_address_taker}"

cc_sell_size_asset="USDT"
# opposite strategy using "*_opposite" variables if exist
cc_sell_size_asset_opposite="USDT"

# automatic maker price gathering
cc_price_redirections='"BLOCK": { "asset": "USDT", "price": 0.023777}'
cc_maker_price=0
cc_maker_price_opposite=0
cc_price_source_argval="--usecg"

# flush all canceled orders every 60 seconds
cc_flush_canceled_orders=60

# first placed orders
cc_sell_start_spread="3.1"
cc_sell_start_spread_opposite="3.1"
cc_sell_start="7"
cc_sell_start_min="2"
# last palced order
cc_sell_end_spread="1.04"
cc_sell_end_spread_opposite="1.04"
cc_sell_end="2"
cc_sell_end_min="2"

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


# static boundaries configuration:
    # set boundaries in specific asset rather than taker
#~ cc_sboundary_asset="USDT"
cc_sboundary_asset="''"
    # boundary set in static specific price
cc_sboundary_max=0
cc_sboundary_min=0
    
    # enabled disable boundary asset price updates. This means, ie if trading BLOCK/BTC but boundary is set in USD, it also do USD/BTC price updates and dynamically update boundary according to.
cc_sboundary_max_track_asset="False"
cc_sboundary_min_track_asset="False"
    
    # Enable reversed pricing as 1/X, ie BLOCK/BTC vs BTC/BLOCK pricing can set like 0.000145 on both bot trading sides, instead of 0.000145 vs 6896.55.
cc_sboundary_max_min_reverse="True"
    
    # maximum boundary hit behavior True/False
    # cancel orders on max boundary. The reason can be user is not willing to continue selling his maker-asset once price is too high bc expected bullmarket and user rather start staking
cc_sboundary_max_cancel="True"
cc_sboundary_max_exit="True"
    # minimum boundary hit behavior True/False
    # do not cancel orders on min boundary, but rather keep open orders on minimum boundary. The reason can be user is not willing to sell his maker-asset by very low price, rather wait for price recover
cc_sboundary_min_cancel="False"
cc_sboundary_min_exit="False"


# set relative maximum and minimum maker price boundaries
    # set relative boundary values in specific asset
    # ie.: Static boundary with maker/taker BLOCK/BTC and boundary_asset is USDT, so possible boundary min 1.5 and max 3 USD (default= --taker)'
cc_rboundary_asset="''"
    # manually set initial center price. Its usable only when some boundary_max/min_asset_track is Disabled
cc_rboundary_price_initial=0
    
    # maximum and minimum acceptable price set as relative value to center price
    # set max at 150% and min 95% of price when bot was started as 1.5 0.95
cc_rboundary_max="1.5"
cc_rboundary_min="0.9"
    
    # Track boundary asset price updates. This means, ie if trading BLOCK/BTC on USD also track USD/BTC price and update boundaries by it
    # True/False
cc_rboundary_max_track_asset="False"
cc_rboundary_min_track_asset="False"
    
    # reversed set pricing as 1/X, ie BLOCK/BTC vs BTC/BLOCK pricing can set like 0.000145 on both bot trading sides, instead of 0.000145 vs 6896.55.'
    # this feature works with relative boundary asset as well
cc_rboundary_price_reverse="False"
    
    # maximum boundary hit behavior True/False
    # cancel orders on max boundary. The reason can be user is not willing to continue selling his maker-asset once price is too high bc expected bullmarket and user rather start staking
cc_rboundary_max_cancel="True"
cc_rboundary_max_exit="True"
    # minimum boundary hit behavior True/False
    # do not cancel orders on min boundary, but rather keep open orders on minimum boundary. The reason can be user is not willing to sell his maker-asset by very low price, rather wait for price recover
cc_rboundary_min_cancel="True"
cc_rboundary_min_exit="False"


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
