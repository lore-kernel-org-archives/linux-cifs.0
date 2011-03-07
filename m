From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: add missing unicode handling routines needed for smb2
Date: Mon, 7 Mar 2011 09:11:56 -0600
Message-ID: <AANLkTi=THwPwxo+AdH6=jY=No5z9Kb-FBTBrQKOM4fD8@mail.gmail.com>
References: <AANLkTinVkEHg-DOp6+0Jq+_vteYaix+nqt=QNFJ7nSML@mail.gmail.com>
	<AANLkTi=88O1KAuOYNeZXLBHm2m_BtutLRNwh5tzut0cM@mail.gmail.com>
	<AANLkTikGTTsJnQY1yntPMq+tX_W2NfETCyfp+P+9p4V0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikGTTsJnQY1yntPMq+tX_W2NfETCyfp+P+9p4V0-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Forgot to cc the list.

On Mon, Mar 7, 2011 at 9:10 AM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Sun, Mar 6, 2011 at 10:46 PM, Shirish Pargaonkar
> <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>> Steve, like local crypto functions were changed to linux crypto APIs,
>> should converting unicode functions local to cifs to unicode APIs (if
>> they exist)
>> be looked at, sometimes down the road?
>
Yes that is done.  The smb2 routines are now
using the cifs unicode APIs but there were two
differences (we may find a few other helpers we have to add
later), so I added to cifs_unicode.c two small
helper routines for calculating the unicode string length and for
unicode string copy (internally they use the cifs unicode
functions).

Also note that SMB2 is unicode only, so the interface to these
two is a little simpler.

Thanks,

Steve




-- 
Thanks,

Steve
