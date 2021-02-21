    -- Extension function to combine multiple headers of the same name into one header.

    function NSTEXT:COMBINE_HEADERS(): NSTEXT

        local headers = {} -- headers

        local combined_headers = {} -- headers with final combined values
        -- Iterate over each header (format "name:valuer\r\n")

        -- and build a list of values for each unique header name.

        for name, value in string.gmatch(self, "([^:]+):([^\r\n]*)\r\n") do

            if headers[name] then

                local next_value_index = #(headers[name]) + 1

                headers[name][next_value_index] = value

            else

                headers[name] = {name .. ":" .. value}

            end

        end

        -- iterate over the headers and concat the values with separator ","

        for name, values in pairs(headers) do

            local next_header_index = #combined_headers + 1

            combined_headers[next_header_index] = table.concat(values, ",")

        end

        -- Construct the result headers using table.concat()

        local result_str = table.concat(combined_headers, "\r\n") .. "\r\n\r\n"

        return result_str

    end