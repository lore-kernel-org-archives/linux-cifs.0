From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Channel Sequence handling - was RE: [PATCH] [SMB3] Send durable
 handle v2 contexts when use of persistent handles required
Date: Mon, 5 Oct 2015 14:50:51 -0500
Message-ID: <CAH2r5msW2+Mbui=jR3r2TaFspEUJFvLZYSQ5AXwGZ7qK2N5fkA@mail.gmail.com>
References: <BN3PR03MB15107EF8D31A9F3B463FD753A0480@BN3PR03MB1510.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BN3PR03MB15107EF8D31A9F3B463FD753A0480-TOgqXkWMcuxshltC/NOAfWP7xZHs9kq/vxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Oct 5, 2015 at 9:44 AM, Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org> wrote:
>> -----Original Message-----
>> From: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-cifs-
>> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Steve French
>> Sent: Saturday, October 3, 2015 10:03 PM
>> ...
>> I don't know if channel sequence number in the SMB3 request would also
>> need to be incremented on disconnect though (the documentation is
>> confusing on that in MS-SMB2) in the case where we only have one
>> channel.
>
> There's nothing special about replay on one channel, after any disconnect you should increment the channel sequence so the server's replay detection can work properly.
>
> Can you point me to the MS-SMB2 text that you find confusing? We can address it.


(the doc text in 3.2.4.1 and 3.2.7.1 of MS-SMB2 seems to
conflict)

On disconnect "If Connection.Dialect belongs to the SMB 3.x dialect
family, and if the Session has more than one channel in
Session.ChannelList, the client MUST perform the following actions:

"Session.ChannelSequence MUST be incremented by 1."

but 3.2.4.1 indicates that it is not just for multichannel but also
for PersistentHandle that it must be incremented (see below)

"If Connection.Dialect belongs to the SMB 3.x dialect family and if
Connection.SupportsMultiChannel or
Connection.SupportsPersistentHandles is TRUE, the
client MUST set ChannelSequence in the SMB2 header to Session.ChannelSequence."


-- 
Thanks,

Steve
