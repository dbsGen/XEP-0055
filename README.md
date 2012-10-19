This is a module for [XMPPFramework](https://github.com/robbiehanson/XMPPFramework) .
It just implement the client part of [XEP-0055](http://xmpp.org/extensions/xep-0055.html). 

##How to use?

Set up it
====================================

It is easy to use. First, get the source code of [XMPPFramework](https://github.com/robbiehanson/XMPPFramework), and put it in your project. 

Then, get a copy of XEP-005(just this project), by:

	get clone https://github.com/dbsGen/XEP-0055.git

And put XEP-0055 in XMPPFramework/Extensions ,just like:

![screenshots](http://zhaorenzhi.cn/wp-content/uploads/2012/09/ss_xep-0055.png)

Code
=====================================

<b>1,Init:</b> 

	_xmppSearchModule = [[XMPPSearchModule alloc] initWithDispatchQueue:_queue];
	_xmppSearchModule.searchHost = @"YOUR_SEARCH_HOST_HERE";
	[_xmppSearchModule activate:_xmppStream];

<b>2,Get the Search Fields:</b>

Using ```-askForFields``` to get the fields.

If use this method you will implement ```-searchModelGetFields:``` in the delegate.

While ```-searchModelGetFields:``` be invoked, ```result``` will be Non-empty.

Then, ```[result copyForSingleFields]``` to get the single fields, the return 
is a array of XMPPSearchNode. And ```[result copyForTableFields]``` to get the 
data forms fields, the return is a array of XMPPSearchNode.


<b>3,Fill the fields</b>

If you know your XMPP server you can skip the step 2, and make your fields.

Make your fields or copy from ```XMPPSearchResult``` to the get the fields.
The fields will be instances of ```XMPPSearchNode```'s subclasses.  

They are defined in ```XMPPSearchNode.h```.

<b>4,Send the search fields to server and get the result</b>

	- (void)searchWithFields:(NSArray*)fields userData:(id)userData;

```fields``` is the fields just said in step 3. And the method support you 

to transfer a ```userData``` , the ```userData``` will be get in the delegate 
of ```-searchModel:result:userData:``` . 

The result is a instance of XMPPSearchReported.


##Others

Maybe, you can find this some thing in XEP-0055 I had not implemented in this project,
you can fork this project and add them.