From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Pfif] [PFIF] Maximum write size
Date: Tue, 15 Nov 2011 11:41:17 -0600
Message-ID: <CAH2r5mvQGTC-K4xrLpY2KaTYKfz14nBe5EQLnNA-A9N1-QpfFQ@mail.gmail.com>
References: <CAH2r5mvOhO9OabDN=GuH_dCp5rABMxWi9qy3-AB_ZD+tgfZ7ng@mail.gmail.com>
	<4EC29E13.8080606@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	"samba-technical-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org Jeff Layton" <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: "Stefan (metze) Metzmacher" <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4EC29E13.8080606-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Nov 15, 2011 at 11:14 AM, Stefan (metze) Metzmacher
<metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> Hi Steve,
>
>> In SMB WriteX (see MS-SMB 2.2.4.3 it says
>>
>> "the CountHigh field. This field is used when the CAP_LARGE_WRITEX
>> capability has been negotiated to allow for file writes larger than
>> 0xFFFF bytes in length."
>>
>> Could we get a clarification on the following:
>>
>> 1) When CAP_LARGE_WRITEX is set, what write sizes must the server
>> support? (we were assuming up to 127K)
>>
>> 2) How does the server indicate that it does not support this maximu=
m
>> size? (e.g. we found a server which set CAP_LARGE_WRITEX and support=
s
>> 100K write but not 127K writes, and returned "INVALID_PARAMETER" for
>> larger writes rather than simply writing the smaller amount). =A0Wha=
t NT
>> Status code must the server return on a write size too large?
>>
>> 3) What is the largest size which Windows clients can send? (and whi=
ch
>> Windows servers will process?) In particular, can Windows clients se=
nd
>> 64K or more in a single write?
>
> You might want to look at cli_write_max_bufsize() in Samba.
> We use "useable_space =3D 0x1FFFF - data_offset", which results
> in a SMB PDU of size 0x1FFFF, which is the maximum size for NBT.
>
> CAP_LARGE_READX however is broken on Windows and we have to truncate
> like this useable_space =3D MIN(useable_space, UINT16_MAX);

Yes - we follow this today, with a result of max write size of 127K
and max read smaller.
The problem is that apparently Solaris has a bug with sizes over 100K.
 Jeff fears
other servers have bugs and wants to limit the write size to less than
64K by default.
His testing in his development environment shows dramatic performance
loss going from 127K to 64K, although my testing showed significant los=
s but
not as bad.

My instinct is to:
1) set the defaults for writes to reasonable value based on all of the
information we
have (I am hoping that additional clues in negotiate, sessionsetup or W=
riteX
response can be used to detect the broken server type) so we don't puni=
sh
the 99% of the servers (Windows, NetApp, EMC, Samba) that handle this
just fine
2) at least log (possibly fall back and alter wsize, and retry if the e=
rror
paths can be determined) when the status code for WriteX
returns INVALID_PARAMETER (apparently Solaris returns this on the first
write) since I can't see anything else that INVALID_PARAMETER is likely
to mean other than - "my server can't handle a big write despite what w=
e
said in our capabilities").   Generally, I prefer that we sensibly retr=
y
writes on errors returned from the server and not sure why this case
should be different (although Jeff says the code path is hard to retry
on, I think it is worth analyzing more carefully just in case since
there are certainly other error codes that writeX should retry on).

Can't smbclient send more than 64K to Windows on writes?


--=20
Thanks,

Steve
