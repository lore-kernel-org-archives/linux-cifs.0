From: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Subject: Re: Linux 3.2.17 and netapp 8.1
Date: Tue, 15 May 2012 19:15:21 +0530
Message-ID: <4FB25DF1.9080402@suse.com>
References: <4FB0FDDA.5080604@orange.com> <20120514120159.2f6de2fa@corrin.poochiereds.net> <4FB12D71.3040403@orange.com> <20120514121824.273198a9@corrin.poochiereds.net> <4FB13173.1070509@orange.com> <20120514131559.7ca0cdc4@corrin.poochiereds.net> <4FB203AE.3020408@orange.com> <20120515090907.39197340@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: eric2.valette-C0LM0jrOve7QT0dZR+AlfA@public.gmane.org, donald.r.gray-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120515090907.39197340-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 05/15/2012 06:39 PM, Jeff Layton wrote:
> On Tue, 15 May 2012 09:20:14 +0200
> VALETTE Eric RD-MAPS-REN <eric2.valette-C0LM0jrOve7QT0dZR+AlfA@public.gmane.org> wrote:
> 
>> On 05/14/2012 07:15 PM, Jeff Layton wrote:
>>>
>>> BTW: I've seen prototype SMB2 support in git tress pushed in october.
>>> Any plan to submit something upstream?
>>>
>>> Thanks for your support,
>>>
>>>
>>> Yes, we're working on it. I think we've come to some consensus on a
>>> basic design and I believe Pavel is now working to forward-port the
>>> previous patches to that design.
>>>
>> OK. Will wait then. Any chance it might helps with the netapp?
>>
>>> In Netapps defense Ontap 8.1 is an early release which are known to be buggy.
>> Well its been released around february if google can be trusted and what 
>> this says is that netapp don't care about Linux support at all and do 
>> not even perform basic test with linux client. I'm rather sure we asked 
>> about linux compatibility before moving from 7.xx to 8.01.
>>
>> -- eric
>>
> 
> For the record...
> 
> The story I've heard in the past (albeit second or third hand) is that
> Netapp is not interested in interop with non-windows clients. It's

Yeah, I have heard similar stories too and from what I have heard from
the NetApp customers, NetApp seems to strongly suggest to use _only_ NFS
with the Linux clients.


Thanks
Suresh
