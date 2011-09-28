From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Mounts to Windows 7 and "out of memory" or "insufficient server resources"
Date: Wed, 28 Sep 2011 13:27:33 -0500
Message-ID: <CAH2r5msGRvhahCXbAb8mj7c28qUzPxOB5dJjjyQFAZvQxZzY-g@mail.gmail.com>
References: <CAH2r5msivsE_47mESmGR=Xjf2v-kKwi-Qpym2kxuTLPbYudisQ@mail.gmail.com>
	<4E82B4ED.4060107@suse.com>
	<20110928080622.5e30429b@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110928080622.5e30429b-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Sep 28, 2011 at 7:06 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Wed, 28 Sep 2011 11:17:25 +0530
> Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org> wrote:
>
>> On 09/28/2011 03:06 AM, Steve French wrote:
>> > FYI - The cifs async write in 3.0 seems to exacerbate problems run=
ning
>> > out of memory (apparently) on the Windows 7 system (running as a
>> > server) after a large file copy to the server completes. =A0 I hav=
e been
>> > able to reproduce the same problem on Windows Vista Service Pack 2
>> > (which is a good news/bad news story since my earlier testing on
>> > Windows Vista showed hangs on some requests rather than returning =
out
>> > of memory). =A0Does not seem to be a problem with any of the Windo=
ws
>> > server versions just Windows 7 and Vista so far.
>>
>> The last time when I encountered this, cifs client was reporting "Ca=
nnot
>> allocate memory" a.k.a -ENOMEM error. But, it is actually a
>> NT_STATUS_INSUFF_SERVER_RESOURCES error from Server being mapped to
>> -ENOMEM. I found this mapping confusing atleast initially. Is this
>> mapping correct?
>>
>> Not sure do we have a POSIX equivalent of
>> NT_STATUS_INSUFF_SERVER_RESOURCES? Should we map it to a error code =
that
>> is more obvious?
>>
>
> Maybe -EREMOTEIO ?

The mapping of NT_STATUS_INSUFFICIENT_SERVER_RESOURCES to posix error
ENOMEM appears to be correct for multiple reasons.  Windows itself maps=
 it this
way when mapping from NT STATUS to DOS errors. For example, on subseque=
nt
requests, I see server returning DOS (!) error for error_no_memory on s=
ome
types of SMBs and NT error insufficient_server_resources on others.



--=20
Thanks,

Steve
