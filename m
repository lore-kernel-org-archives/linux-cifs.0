From: "Shane McColman" <smccolman-WkVietXGWdS4IGBGpn4MSVaTQe2KTcn/@public.gmane.org>
Subject: RE: CIFS VFS errors
Date: Mon, 27 Jun 2011 17:34:39 -0600
Message-ID: <E6636E53DE0A4D2688B177557D4D19F2@dynamicsourcemfg.local>
References: <4BEC36376CA24EBFAA83C16B955BD9CC@dynamicsourcemfg.local><20110608164415.5b8cbf4b@tlielax.poochiereds.net><7A5FF1B06368450BAE39549CE3C621CF@dynamicsourcemfg.local><20110622163251.16499f4b@tlielax.poochiereds.net><AC93F84448C9430AB4B791EE591F2F97@dynamicsourcemfg.local><6753F891F47C4E9CBDFB66A63A8E1367@dynamicsourcemfg.local><BANLkTi=T+=yaQ7MH7g+gmqjFgP2HX4iqJg@mail.gmail.com><BCB6EBAD1FD74D7B91FBD8B0FA614384@dynamicsourcemfg.local><20110623133759.2c3f4aab@barsoom.rdu.redhat.com><8A647BDD88F1473AAE69C405E3C65EB1@dynamicsourcemfg.local><20110623143000.62f882ed@tlielax.poochiereds.net><4C4F2F3EB4B94403969BF63208AB0831@dynamicsourcemfg.local><20110623153533.4adafcd6@tlielax.poochiereds.net><9171CA638C0A474598851C87B7C92CC0@dynamicsourcemfg.local><20110623171112.71cc4e98@tlielax.poo
 chiereds.net> <20110623171442.22d13bec@tlielax.poochiereds.net> <AB1032AA058748FFA44899ED551710C6@dynamicsourcemfg.local>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
To: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AB1032AA058748FFA44899ED551710C6-WkVietXGWdS4IGBGpn4MSbjjLBE8jN/0@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


Kernel errors have dropped significantly (only 2 during the day today).  No
errors in copying files.

Thanks for all the help.  I really do appreciate it.

Shane

>I verified that Windows XP only allows a max of 10 connections as set by
>Microsoft.  This machine already has 5 connections from the 5 pieces of
>equipment here, so I'm left with 5. For this reason I set
>cifs_max_pending=4
>to stay on the safe side.  That was at 9:30 this morning and have not had
>an
>error since.  I'll check again on Monday and give you an update.
