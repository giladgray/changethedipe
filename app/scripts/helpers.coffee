define ['jquery'], ($) ->
	# removes the given class from all elements (optionally within scope selector)
	# and applies it to this element. useful for singleton class, such as .active
	$.fn.takeClass = (targetClass, scope='') ->
		$(scope + " ." + targetClass).removeClass targetClass
		@addClass targetClass

	# removes the old class and adds the new one
	$.fn.swapClass = (oldClass, newClass) ->
		@removeClass(oldClass).addClass(newClass)
