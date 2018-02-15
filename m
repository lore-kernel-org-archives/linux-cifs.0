From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Does smbfs use 1 socket per target?
Date: Thu, 15 Feb 2018 14:35:06 -0600
Message-ID: <CAH2r5muL02fnraSj1SjjiY5qXsjYYTGN-GQuzONGJKremXKrSg@mail.gmail.com>
References: <CAMfosPGqMdRfTzEuALqq46PjKQN5AMhQovx-bFXJ=wa1qFVivg@mail.gmail.com>
 <CAH2r5mukP7-7bOGomC1_9axm0exDdvWYB5e2zTckyJcVLEmb=A@mail.gmail.com> <CAMfosPGdO2AcODZuoAgyGe47ssz9W6xg-4=-kF5yXxfhr0n=AA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: CIFS <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Matthew DeLoera <mmdeloera-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAMfosPGdO2AcODZuoAgyGe47ssz9W6xg-4=-kF5yXxfhr0n=AA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If talking about the server side, this is a better topic for
samba-technical mailing list.

On the server smbd launches a new process for each new client which
connects to it.

On Thu, Feb 15, 2018 at 2:27 PM, Matthew DeLoera <mmdeloera-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Thanks Steve - that's exactly what I want to know.
>
> I'm also curious about the tgtd side. According to smbd's manpage, by
> default there is no limit to the number of connections or smbd
> processes. Will any number of incoming clients all be handled by a
> single smbd process if the same credentials are used for all? Are
> there any other criteria that inform the total number of smbd
> processes?
>
> On Thu, Feb 15, 2018 at 2:00 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> On Thu, Feb 15, 2018 at 11:58 AM, Matthew DeLoera <mmdeloera-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>> I'm sorry if this is a vague question, but I hope someone can correct
>>> or affirm my understanding of smbfs socket behavior.
>>
>> presumably you mean cifs.ko (CIFS/SMB3 kernel driver for Linux).  "smbfs"
>> is the name of the Mac (not Linux) driver (there was a much older
>> smbfs 20 years ago for Linux that predated cifs.ko)
>>
>>
>>> I read in the mount.cifs manpage for the "port=" option that it will
>>> use an existing connection to that port. So does this mean that
>>> regardless of how many files might be concurrently open on a single
>>> share, regardless how many processes are executing I/O requests, smbfs
>>> multiplexes all associated I/O blocks through the same single TCP
>>> connection?
>>
>> Unlike Windows (which will use multiple connections to the same ip
>> address depending on what the server reports about its network
>> adapter), cifs.ko will only establish one socket connection to each
>> distinct ip address that it is mounted to.   In the future, as SMB3
>> "multi-channel" support progresses, you will see cases where multiple
>> connections are made for a mount from one client to one server
>> (depending on what the server reports as its available adapters).
>>
>>> Is it a persistent connection for as long as the mount exists? (i.e.
>>> I'm using an fstab entry) Granted I know how to use netstat, but
>>> hoping someone might note something authoritative.
>>
>> The server can (and will if no open files) sometimes disconnect the socket
>> (client reconnects automatically).  In addition, if the server is unresponsive
>> (does not respond to periodic SMB3 "echo" requests) the client will
>> drop the connection and reconnect.
>>
>>> Can I infer that if I have 5 fstab entries to unique hosts, and mount
>>> -a, I'll have 5 outbound TCP connections?
>>
>> Yes
>>
>> --
>> Thanks,
>>
>> Steve



-- 
Thanks,

Steve
