From: Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Implementing some SMB2.2/3.0 features ...
Date: Sun, 29 Jul 2012 14:32:18 -0700
Message-ID: <CACyXjPz_iQc2m2O5dnMttxQxPv3CVsq5ycHLgbDgzi-gYg-PuQ@mail.gmail.com>
References: <CACyXjPz1fVUKADaan72krJCf-21e1QOrm2s1TEEAxR_S5mk0NQ@mail.gmail.com>
	<20120729092806.4e2b657e@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120729092806.4e2b657e-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, Jul 29, 2012 at 6:28 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Sat, 28 Jul 2012 08:19:48 -0700
> Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> Hi folks,
>>
>> I have started looking at implementing some of the SMB3.0 features.
>> This is because, in order to do SMB Direct I need multi-connect.
>>
>> In reading the latest version of the spec ([MS-SMB2] dated July 5,
>> 2012 and available from msdn.microsoft.com) I notice that each sessi=
on
>> should have a channel list, which is a list of objects containing a
>> connection reference and a signing key. It also should have a channe=
l
>> sequence number.
>>
>> This means that I will need to change the struct cifs_ses to have a
>> channel list rather than a struct TCP_Server_Info.
>>
>> In addition, multi-connect allows multiple connections to the same
>> actual server, since it allows a session to use multiple TCP
>> connection on a GbE or 10GbE link. So, it seems that I will need to
>> introduce an explicit notion of a connection, which the code does no=
t
>> currently have. This will definitely be needed for SMB Direct, becau=
se
>> the model is that you establish a connection to the server on TCP,
>> negotiate a protocol and then establish a session and then send an
>> FSCTL to discover the (common) set of interfaces the server has. Aft=
er
>> that, if you notice that the client and server have an RDMA-capable
>> interface in common, you establish a connection via that interface,
>> negotiate protocol and then create a session (session setup) but bin=
d
>> it to the existing session.
>>
>> Does anyone have any comments at this stage? This seems like a
>> significant undertaking :-)
>>
>
> It sounds like you're on the right track. Essentially I think you nee=
d
> to abstract out the parts of the TCP_Server_Info that are specific to
> the socket, and put them in a new struct that will hang off of the
> TCP_Server_Info in some way (maybe a linked list of "smb_connection"
> structs?)

Hmmm, actually, I think that the TCP_Server_Info should be renamed
cifs_tcp_connection or something like that.

Then 3.2.1.3 of [MS-SMB2] says that if the client implements version
2.2/3.0 of SMB2, it should also have a ChannelList (an array/list of
connection and SigningKey pairs) a ChannelSequence and a few other
bits.

Of course, these are only relevant if you are talking to a server that
implements the 2.2/3.0 dialect of SMB2. So, I need to think about how
to deal with this.

Then I need to think about how to handle Infiniband Connection objects
because they have a little protocol of their own, so they need a
proto_ops structure, while a TCP connection already has that.

Then, there is the issue of using socket callbacks for TCP. Infiniband
is event driven, and I need to look at the model to see if we can
unify socket callbacks and Infiniband events, which use callbacks.

--=20
Regards,
Richard Sharpe
(=A6=F3=A5H=B8=D1=BC~=A1H=B0=DF=A6=B3=A7=F9=B1d=A1C--=B1=E4=BE=DE)
