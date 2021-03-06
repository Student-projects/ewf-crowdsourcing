note
	description: "Summary description for {SIGNUP_PAGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SUPPORT_PAGE

inherit

	BASE_PAGE
		redefine
			initialize_controls
		end

create
	make

feature {NONE}

	initialize_controls
		local
			button1: WSF_BUTTON_CONTROL
			amount: WSF_INPUT_CONTROL
		do
			Precursor
			navbar.set_active (2)
			main_control.add_column (3)
			main_control.add_column (6)
			main_control.add_column (3)
			main_control.add_control (2, create {WSF_BASIC_CONTROL}.make_with_body ("h1", "", "Support project"))
			load_reward
			create form.make
			create amount.make ("")
			create amount_container.make ("Amount", amount)
			if attached reward ["amount"] as a then
				amount_container.add_validator (create {WSF_AGENT_VALIDATOR [STRING]}.make (agent validate_amount, "Minimal amount is " + a.out))
			end
			form.add_control (amount_container)
			main_control.add_control (2, form)
		end

	handle_click
		do
			form.validate
			if form.is_valid then
			end
		end

feature -- Validation

	validate_amount (amount: STRING): BOOLEAN
		do
			if amount.is_integer then
				if attached reward ["amount"] as a_amount and then attached {INTEGER} a_amount as a and then amount.to_integer >= a then
					Result := True
				else
				end
			end
		end

feature -- Implementation

	load_reward
		local
			query: SQL_QUERY [SQL_ENTITY]
			condition: SQL_CONDITIONS
		do
			if attached request.path_parameter ("reward_id") as id then
				create query.make ("rewards")
				query.set_fields (<<["id"], ["amount"]>>)
				create condition.make_condition ("AND")
				condition ["id"].equals (id.string_representation)
				query.set_where (condition)
				reward := query.run (database).first
			else
				create reward.make
			end
		end

	process
		do
		end

feature -- Properties

	reward: SQL_ENTITY

	amount_container: WSF_FORM_ELEMENT_CONTROL [STRING]

	form: WSF_FORM_CONTROL

end
