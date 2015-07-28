local yaoui_path = (...):sub(1, -12)
local YaouiTheme = {}

YaouiTheme.font_awesome = require(yaoui_path .. '.FontAwesome')
YaouiTheme.font_awesome_path = yaoui_path .. '/fonts/fontawesome-webfont.ttf'
YaouiTheme.open_sans_regular = yaoui_path .. '/fonts/OpenSans-Regular.ttf'
YaouiTheme.open_sans_bold = yaoui_path .. '/fonts/OpenSans-Bold.ttf'
YaouiTheme.open_sans_semibold = yaoui_path .. '/fonts/OpenSans-Semibold.ttf'
YaouiTheme.hand_cursor = love.mouse.getSystemCursor("hand")
YaouiTheme.ibeam = love.mouse.getSystemCursor("ibeam")

-- Button
YaouiTheme.Button = {}
YaouiTheme.Button.new = function(self)
    self.color = {31, 55, 95}
    self.timer = self.yui.Timer()
end

YaouiTheme.Button.update = function(self, dt)
    self.timer:update(dt)
end

YaouiTheme.Button.draw = function(self)
    if self.enter then self.timer:tween('color', 0.25, self, {color = {34, 86, 148}}, 'linear')
    elseif self.exit then self.timer:tween('color', 0.25, self, {color = {31, 55, 95}}, 'linear')
    elseif self.hot and self.pressed then self.timer:tween('color', 0.1, self, {color = {36, 104, 204}}, 'linear')
    elseif self.released then 
        if self.hot then self.timer:tween('color', 0.2, self, {color = {34, 86, 148}}, 'linear')
        else self.timer:tween('color', 0.2, self, {color = {31, 55, 95}}, 'linear') end
    end

    if self.yui.debug_draw then
        love.graphics.setColor(222, 80, 80)
        love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
    end

    love.graphics.setColor(unpack(self.color))
    love.graphics.rectangle('line', self.x, self.y, self.w, self.h, self.w/16, self.w/16)
    love.graphics.rectangle('fill', self.x, self.y, self.w, self.h, self.w/16, self.w/16)

    love.graphics.setColor(222, 222, 222)
    local font = love.graphics.getFont()
    love.graphics.setFont(self.font)
    if self.icon then
        if self.parent.icon_right then
            love.graphics.setColor(222, 222, 222)
            love.graphics.print(self.text, self.x + self.parent.size/2, self.y + math.floor(self.parent.size*0.7/2) - self.parent.size/20)
            if self.parent.loading then love.graphics.setColor(45, 117, 223) end
            love.graphics.print(self.icon, self.x + self.parent.size/2 + self.font:getWidth(self.icon)/2 + self.font:getWidth(self.text .. ' '), 
                                self.y + math.floor(self.parent.size*0.7/2) + self.font:getHeight()/2 - self.parent.size/20, 
                                self.parent.icon_r, 1, 1, self.font:getWidth(self.icon)/2, self.font:getHeight()/2)
        else
            if self.parent.loading then love.graphics.setColor(45, 117, 223) end
            love.graphics.print(self.icon, self.x + self.parent.size/2 + self.font:getWidth(self.icon)/2, 
                                self.y + math.floor(self.parent.size*0.7/2) + self.font:getHeight()/2 - self.parent.size/20, 
                                self.parent.icon_r, 1, 1, self.font:getWidth(self.icon)/2, self.font:getHeight()/2)
            love.graphics.setColor(222, 222, 222)
            love.graphics.print(self.text, self.x + self.parent.size/2 + self.font:getWidth(self.parent.original_icon .. ' '), self.y + math.floor(self.parent.size*0.7/2) - self.parent.size/20)
        end
    else love.graphics.print(self.text, self.x + self.parent.size/2, self.y + math.floor(self.parent.size*0.7/2) - self.parent.size/20) end
    love.graphics.setFont(font)
    love.graphics.setColor(255, 255, 255)
end

-- Checkbox
YaouiTheme.Checkbox = {}
YaouiTheme.Checkbox.new = function(self)
    self.check_alpha = 255
    self.check_draw = false
    self.timer = self.yui.Timer()
end

YaouiTheme.Checkbox.update = function(self, dt)
    self.timer:update(dt)
end

YaouiTheme.Checkbox.draw = function(self)
    if self.checked_enter then 
        self.check_alpha = 255
        self.check_draw = true
    elseif self.checked_exit then self.timer:tween('check', 0.15, self, {check_alpha = 0}, 'linear', function() self.check_draw = false end) end

    if self.yui.debug_draw then
        love.graphics.setColor(222, 80, 80)
        love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
    end

    love.graphics.setColor(222, 222, 222)
    local font = love.graphics.getFont()
    love.graphics.setFont(self.font)
    love.graphics.print(self.text, self.x + self.font:getWidth(self.icon .. '  '), self.y + math.floor(self.parent.size*0.7/2))
    love.graphics.setColor(84, 84, 84)
    love.graphics.rectangle('line', self.x, self.y + self.h/4, 2*self.h/4, 2*self.h/4, self.w/32, self.w/32)
    love.graphics.rectangle('fill', self.x, self.y + self.h/4, 2*self.h/4, 2*self.h/4, self.w/32, self.w/32)
    love.graphics.setColor(75, 194, 244, self.check_alpha)
    if self.check_draw then love.graphics.print(self.icon, self.x + self.parent.size/20, self.y + math.floor(self.parent.size*0.7/2) - self.parent.size/18) end
    love.graphics.setFont(font)
    love.graphics.setColor(255, 255, 255)
end

-- Dropdown
YaouiTheme.Dropdown = {}
YaouiTheme.Dropdown.draw = function(self)
    if self.yui.debug_draw then
        love.graphics.setColor(222, 80, 80)
        love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
    end
    
    local text_color = {188, 190, 192}
    if self.hot then text_color = {255, 255, 255} end

    love.graphics.setColor(unpack(text_color))
    local font = love.graphics.getFont()
    love.graphics.setFont(self.font)
    love.graphics.print(self.title .. '   ', self.x, self.y + math.floor(self.parent.size*0.7/2))
    love.graphics.setColor(43, 110, 210)
    love.graphics.print(self.parent.options[self.parent.current_option] .. ' ', 
                        self.x + self.font:getWidth(self.title .. '   '), 
                        self.y + math.floor(self.parent.size*0.7/2))
    love.graphics.setColor(unpack(text_color))
    love.graphics.print(self.icon, 
                        self.x + self.font:getWidth(self.title .. '   ' .. self.parent.options[self.parent.current_option] .. ' '), 
                        self.y + math.floor(self.parent.size*0.7/2.5))
    love.graphics.setFont(font)
    love.graphics.setColor(255, 255, 255)
end

YaouiTheme.DropdownScrollarea = {}
YaouiTheme.DropdownScrollarea.draw = function(self)
    -- Draw scrollarea frame
    love.graphics.setColor(32, 32, 32, 220)
    love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)

    -- Draw scrollbars background
    love.graphics.setScissor()
    love.graphics.setColor(128, 131, 135, 255)
    if self.show_scrollbars then
        if self.vertical_scrolling then
            love.graphics.rectangle('fill', 
                                    self.x + self.area_width,
                                    self.y + self.scroll_button_height,
                                    self.scroll_button_width,
                                    self.area_height - 2*self.scroll_button_height)
        end
        if self.horizontal_scrolling then
            love.graphics.rectangle('fill', 
                                    self.x + self.scroll_button_width,
                                    self.y + self.area_height,
                                    self.area_width - 2*self.scroll_button_width,
                                    self.scroll_button_height)
        end
    end
end

YaouiTheme.DropdownButton = {}
YaouiTheme.DropdownButton.new = function(self)
    self.timer = self.yui.Timer()
    self.add_x = 0
    self.alpha = 220 
    self.draw_bg = false
end

YaouiTheme.DropdownButton.update = function(self, dt)
    self.timer:update(dt)
end

YaouiTheme.DropdownButton.draw = function(self)
    if self.dropdown_selected then
        love.graphics.setColor(20, 32, 48, 220)
        love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
    elseif self.draw_bg then
        love.graphics.setColor(20, 32, 48, self.alpha)
        love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
    end

    if self.enter then 
        self.draw_bg = true
        self.timer:tween('add_x', 0.2, self, {add_x = self.size/4}, 'in-out-cubic') 
        self.timer:tween('bg', 0.1, self, {alpha = 220}, 'linear')
    end
    if self.exit then 
        self.timer:tween('add_x', 0.1, self, {add_x = 0}, 'in-out-cubic') 
        self.timer:tween('bg', 0.1, self, {alpha = 0}, 'linear', function() self.draw_bg = false end) 
    end

    if self.hot then
        love.graphics.setColor(43, 110, 210)
        love.graphics.rectangle('fill', self.x, self.y, self.add_x, self.h)
    end

    if self.dropdown_selected then
        self.add_x = self.size/4
        love.graphics.setColor(188, 190, 192)
        love.graphics.rectangle('fill', self.x, self.y, self.size/4, self.h)
    end

    if self.hot or self.dropdown_selected then love.graphics.setColor(255, 255, 255)
    else love.graphics.setColor(188, 190, 192) end
    local font = love.graphics.getFont()
    love.graphics.setFont(self.font)
    love.graphics.print(self.text, self.x + self.size + self.add_x, self.y + math.floor(self.size*0.65/2))
    love.graphics.setFont(font)
    love.graphics.setColor(255, 255, 255)
end

-- FlatDropdown
YaouiTheme.FlatDropdown = {}
YaouiTheme.FlatDropdown.draw = function(self)
    if self.yui.debug_draw then
        love.graphics.setColor(222, 80, 80)
        love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
    end

    love.graphics.setColor(57, 59, 61)
    love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
    
    love.graphics.setColor(222, 222, 222)
    local font = love.graphics.getFont()
    love.graphics.setFont(self.font)
    love.graphics.print(self.parent.options[self.parent.current_option] .. ' ', 
                        self.x + self.parent.size/3, 
                        self.y + math.floor(self.parent.size*0.7/2) - self.parent.size/20)
    love.graphics.print(self.icon, 
                        self.x + self.w - self.parent.size/3 - self.font:getWidth(self.icon), 
                        self.y + math.floor(self.parent.size*0.7/2.5) - self.parent.size/20)
    love.graphics.setFont(font)
    love.graphics.setColor(255, 255, 255)
end

YaouiTheme.FlatDropdownScrollarea = {}
YaouiTheme.FlatDropdownScrollarea.draw = function(self)
    love.graphics.setLineStyle('rough')
    -- Draw scrollarea frame
    love.graphics.setColor(57, 59, 61, 255)
    love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
    love.graphics.setColor(127, 157, 185, 255)
    love.graphics.rectangle('line', self.x + 1, self.y, self.w - 2, self.h)

    -- Draw scrollbars background
    love.graphics.setScissor()
    love.graphics.setColor(128, 131, 135, 255)
    if self.show_scrollbars then
        if self.vertical_scrolling then
            love.graphics.rectangle('fill', 
                                    self.x + self.area_width,
                                    self.y + self.scroll_button_height,
                                    self.scroll_button_width,
                                    self.area_height - 2*self.scroll_button_height)
        end
        if self.horizontal_scrolling then
            love.graphics.rectangle('fill', 
                                    self.x + self.scroll_button_width,
                                    self.y + self.area_height,
                                    self.area_width - 2*self.scroll_button_width,
                                    self.scroll_button_height)
        end
    end
    love.graphics.setLineStyle('smooth')
end

YaouiTheme.FlatDropdownButton = {}
YaouiTheme.FlatDropdownButton.draw = function(self)
    love.graphics.setLineStyle('rough')
    if self.dropdown_selected then
        love.graphics.setColor(30, 144, 255)
        love.graphics.rectangle('fill', self.x + 1, self.y, self.w - 3, self.h)
    end

    if self.hot then
        love.graphics.setColor(30, 144, 255)
        love.graphics.rectangle('fill', self.x + 1, self.y, self.w - 3, self.h)
    end
    love.graphics.setLineStyle('smooth')

    if self.hot or self.dropdown_selected then love.graphics.setColor(255, 255, 255)
    else love.graphics.setColor(188, 190, 192) end
    local font = love.graphics.getFont()
    love.graphics.setFont(self.font)
    love.graphics.print(self.text, self.x + self.parent.size/3, self.y)
    love.graphics.setFont(font)
    love.graphics.setColor(255, 255, 255)
end

-- FlatTextinput
YaouiTheme.FlatTextinput = {}
YaouiTheme.FlatTextinput.draw = function(self)
    love.graphics.setLineStyle('rough')

    local font = love.graphics.getFont()
    love.graphics.setFont(self.font)

    -- Draw textinput background
    love.graphics.setColor(57, 59, 61)
    love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)

    -- Draw selected text with inverted color and blue selection background
    if self.selection_index and self.index ~= self.selection_index then
        love.graphics.setColor(198, 198, 198)
        self.text:draw()

        if self.selected then
            love.graphics.setColor(51, 153, 255)
            for i, _ in ipairs(self.selection_positions) do
                love.graphics.rectangle('fill', self.selection_positions[i].x, self.selection_positions[i].y, self.selection_sizes[i].w, self.selection_sizes[i].h)
            end

            love.graphics.setColor(255, 255, 255)
            if love_version == '0.9.1' or love_version == '0.9.2' then
                for i, _ in ipairs(self.selection_positions) do
                    love.graphics.setStencil(function() 
                        love.graphics.rectangle('fill', self.selection_positions[i].x, self.selection_positions[i].y, self.selection_sizes[i].w, self.selection_sizes[i].h)
                    end)
                    self.text:draw()
                    love.graphics.setStencil()
                end
            else
                for i, _ in ipairs(self.selection_positions) do
                    love.graphics.stencil(function() 
                        love.graphics.rectangle('fill', self.selection_positions[i].x, self.selection_positions[i].y, self.selection_sizes[i].w, self.selection_sizes[i].h)
                    end)
                    love.graphics.setStencilTest(true)
                    self.text:draw()
                    love.graphics.setStencilTest(false)
                end
            end
        end

    -- Draw text normally + cursor
    else
        love.graphics.setColor(198, 198, 198)
        self.text:draw()

        if self.selected and self.cursor_visible then 
            love.graphics.setColor(198, 198, 198)
            for i, _ in ipairs(self.selection_positions) do
                love.graphics.line(self.selection_positions[i].x, self.selection_positions[i].y, 
                self.selection_positions[i].x, self.selection_positions[i].y + self.selection_sizes[i].h)
            end
        end
    end

    love.graphics.setLineStyle('smooth')
    love.graphics.setColor(255, 255, 255, 255)

    if self.yui.debug_draw then
        love.graphics.setColor(222, 80, 80)
        love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
    end

    love.graphics.setFont(font)
    love.graphics.setColor(255, 255, 255)
end

-- HorizontalSeparator
YaouiTheme.HorizontalSeparator = {}
YaouiTheme.HorizontalSeparator.draw = function(self)
    if self.yui.debug_draw then
        love.graphics.setColor(222, 80, 80)
        love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
    end

    love.graphics.setColor(160, 160, 160)
    love.graphics.setLineStyle('rough')
    love.graphics.line(self.x + self.margin_left, self.y + self.size/2, self.x + self.w - self.margin_left - self.margin_right, self.y + self.size/2)
    love.graphics.setLineStyle('smooth')
    love.graphics.setColor(255, 255, 255)
end

-- IconButton
YaouiTheme.IconButton = {}
YaouiTheme.IconButton.new = function(self)
    self.color = {unpack(self.parent.base_color)}
    self.timer = self.yui.Timer()
end

YaouiTheme.IconButton.update = function(self, dt)
    self.timer:update(dt)
end

YaouiTheme.IconButton.draw = function(self)
    if self.enter then self.timer:tween('color', 0.25, self, {color = {unpack(self.parent.hover_color)}}, 'linear')
    elseif self.exit then self.timer:tween('color', 0.25, self, {color = {unpack(self.parent.base_color)}}, 'linear') end

    if self.yui.debug_draw then
        love.graphics.setColor(222, 80, 80)
        love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
    end

    love.graphics.setColor(unpack(self.color))
    local font = love.graphics.getFont()
    love.graphics.setFont(self.font)
    love.graphics.print(self.icon, self.x + self.w/10, self.y + self.h/64)
    love.graphics.setFont(font)
    love.graphics.setColor(255, 255, 255)
end

-- ImageButton
YaouiTheme.ImageButton = {}
YaouiTheme.ImageButton.new = function(self)
    self.alpha = 0
    self.timer = self.yui.Timer()
end

YaouiTheme.ImageButton.update = function(self, dt)
    self.timer:update(dt)
end

YaouiTheme.ImageButton.draw = function(self)
    if self.enter then self.timer:tween('alpha', 0.1, self, {alpha = 255}, 'linear')
    elseif self.exit then self.timer:tween('alpha', 0.1, self, {alpha = 0}, 'linear') end

    love.graphics.stencil(function()
        if self.rounded_corners then love.graphics.rectangle('fill', self.x, self.y, self.w, self.h, self.w/64, self.w/64)
        else love.graphics.rectangle('fill', self.x, self.y, self.w, self.h) end
    end)
    love.graphics.setStencilTest(true)
    love.graphics.draw(self.parent.img, self.x - self.parent.ix, self.y - self.parent.iy)
    love.graphics.setStencilTest(false)

    if self.parent.overlay then self.parent.overlay(self.parent) end

    love.graphics.setLineWidth(2.5)
    local r, g, b = unpack(self.parent.hover_color)
    love.graphics.setColor(r, g, b, self.alpha)
    love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setLineWidth(1)
end

-- Text
YaouiTheme.Text = {}
YaouiTheme.Text.draw = function(self)
    if self.yui.debug_draw then
        love.graphics.setColor(222, 80, 80)
        love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
    end

    love.graphics.setColor(unpack(self.color))
    local font = love.graphics.getFont()
    love.graphics.setFont(self.font)
    love.graphics.print(self.text, self.x + self.size/6, self.y + self.font:getHeight()/2 + self.size/4)
    love.graphics.setFont(font)
    love.graphics.setColor(255, 255, 255)
end

-- Textinput
YaouiTheme.Textinput = {}
YaouiTheme.Textinput.draw = function(self)
     love.graphics.setLineStyle('rough')

    local font = love.graphics.getFont()
    love.graphics.setFont(self.font)

    -- Draw textinput background
    love.graphics.setColor(12, 12, 12)
    love.graphics.rectangle('fill', self.x, self.y, self.w, self.h, self.h/4, self.h/4)

    -- Draw selected text with inverted color and blue selection background
    if self.selection_index and self.index ~= self.selection_index then
        love.graphics.setColor(198, 198, 198)
        self.text:draw()

        if self.selected then
            love.graphics.setColor(51, 153, 255)
            for i, _ in ipairs(self.selection_positions) do
                love.graphics.rectangle('fill', self.selection_positions[i].x, self.selection_positions[i].y, self.selection_sizes[i].w, self.selection_sizes[i].h)
            end

            love.graphics.setColor(255, 255, 255)
            if love_version == '0.9.1' or love_version == '0.9.2' then
                for i, _ in ipairs(self.selection_positions) do
                    love.graphics.setStencil(function() 
                        love.graphics.rectangle('fill', self.selection_positions[i].x, self.selection_positions[i].y, self.selection_sizes[i].w, self.selection_sizes[i].h)
                    end)
                    self.text:draw()
                    love.graphics.setStencil()
                end
            else
                for i, _ in ipairs(self.selection_positions) do
                    love.graphics.stencil(function() 
                        love.graphics.rectangle('fill', self.selection_positions[i].x, self.selection_positions[i].y, self.selection_sizes[i].w, self.selection_sizes[i].h)
                    end)
                    love.graphics.setStencilTest(true)
                    self.text:draw()
                    love.graphics.setStencilTest(false)
                end
            end
        end

    -- Draw text normally + cursor
    else
        love.graphics.setColor(198, 198, 198)
        self.text:draw()

        if self.selected and self.cursor_visible then 
            love.graphics.setColor(198, 198, 198)
            for i, _ in ipairs(self.selection_positions) do
                love.graphics.line(self.selection_positions[i].x, self.selection_positions[i].y, 
                self.selection_positions[i].x, self.selection_positions[i].y + self.selection_sizes[i].h)
            end
        end
    end

    love.graphics.setLineStyle('smooth')
    love.graphics.setColor(255, 255, 255, 255)

    if self.yui.debug_draw then
        love.graphics.setColor(222, 80, 80)
        love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
    end

    love.graphics.setFont(font)
    love.graphics.setColor(255, 255, 255)
end

return YaouiTheme
