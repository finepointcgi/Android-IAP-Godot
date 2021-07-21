extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var billing
var itemToken

# Called when the node enters the scene tree for the first time.
func _ready():
	if Engine.has_singleton("GodotGooglePlayBilling"):
		billing = Engine.get_singleton("GodotGooglePlayBilling")
		billing.connect("connected", self, "connected") # fired when you connect to the google api
		billing.connect("disconnected", self, "disconnected") # fired when you disconnect 
		billing.connect("connect_error", self, "connect_error") # fired when you cant connect
		billing.connect("purchases_updated", self, "purchases_updated") # fired when you get your purchases
		billing.connect("purchase_error", self, "purchase_error") # fired when you cant get any purchases
		billing.connect("sku_details_query_completed", self, "sku_details_query_completed") # fired when you get your sku details
		billing.connect("sku_details_query_error", self, "sku_details_query_error") # fired when you cant get you sku details
		billing.connect("purchase_acknowledged", self, "purchase_acknowledged")# fired when you purchase something
		billing.connect("purchase_acknowledgement_error", self, "purchase_acknowledgement_error") # fired when you cant purchase something
		billing.connect("purchase_consumed", self, "purchase_consumed") #fired when you use an item
		billing.connect("purchase_consumption_error", self, "purchase_consumption_error") # fired when you cant consume something
		billing.startConnection()
	pass # Replace with function body.

func connected():
	billing.querySkuDetails(["testsku"], "inapp")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func sku_details_query_completed(details):
	print(details)
	
func purchases_updated(items):
	for item in items:
		if !item.is_acknowledged:
			print("acknowledge Purchases: " + item.purchase_token)
			billing.acknowledgePurchase(item.purchase_token)
	if items.size() > 0:
		itemToken = items[items.size() - 1].purchase_token

func purchase_acknowledged(token):
	print("purchase was acknowledged! " + token)

func purchase_consumed(token):
	print("item was consumed " + token)

func _on_Puchase_Item_button_down():
	var response = billing.purchase("testsku")
	print("purchase has been attempted : result " + response.status)
	if response.status != OK:
		print("error purchasing item")
	pass # Replace with function body.


func _on_Use_Item_button_down():
	if itemToken == null:
		print("Error you need to buy this first")
	else:
		print("consuming item")
		billing.consumePurchase(itemToken)
	pass # Replace with function body.
