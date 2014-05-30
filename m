From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Question: mounted windows share suspends or hangs periodically
Date: Thu, 29 May 2014 23:04:41 -0500
Message-ID: <CADT32eJC2AbazhhN869qLYE8L_NEkT4bQe0FY0Xx=VNcd6fnrg@mail.gmail.com>
References: <CAGiTGz8ryG+ALwN6pLCjXzqQEAgohWtpJJ4wyyc7L4D2THTrQg@mail.gmail.com>
	<CAH2r5msMiHmrpvt0UfK6W1t5MekKoSmw0=F7oqX-_OkVjdN9pA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Denys Sobchyshak <denys.sobchyshak-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msMiHmrpvt0UfK6W1t5MekKoSmw0=F7oqX-_OkVjdN9pA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

You can try tcpdump command on the linux client with -s as256 or 512 so as to
minimize or eliminate packet drop  just before you issue ls -l command.
You can save the tcpdump output in a file and bring that file up using
wireshark to look
at smb traffic.

Also, you can turn on auditing on the Windows 2012 server and look in
event log for event
id of 5145 (it will show accesses to the (share) file/files) and see
if you can conclude
anything that way.



On Thu, May 29, 2014 at 12:03 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Thu, May 29, 2014 at 11:02 AM, Denys Sobchyshak
> <denys.sobchyshak-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> Hi cifs community,
>>
>> Problem: periodically (meaning that I don't know how to reproduce it)
>> mounted windows share becomes inaccessible i.e. a simple ls -l command
>> takes hours to output anything (normally it outputs the contents in
>> the end though).
>>
>> Environment: MS Hyper-V with Server 2012 as a host facilitating
>> communication between CentOS 6.4 and MS Server 2012 guests (everything
>> 64-bit). On windows the folder was marked as public share. On CentOS
>> cift-utils was installed and fstab entry looks as follows:
>>
>> //192.168.178.202/share /mnt/share          cifs
>> uid=504,username=myuser,dom=mydomain,password=mypassword,iocharset=utf8,noperm,ro
>> 0 0
>>
>> Note: Parallel to it there's also a network attached storage mounted
>> with linux installed on it and has never failed me even with enabled
>> suspend and hibernate modes. Also I can't find them now, but I've
>> noticed some warnings in centOS logs saying that it failed to open a
>> socket or something alike. Also I've asked this question before and
>> found a workaround which doesn't help anymore.
>> http://superuser.com/questions/678855/windows-share-is-not-accessible-from-time-to-time
>>
>> Question: since I'm not much of a network guy I can't find where the
>> problem is located and am not even sure how to look for it so I would
>> appreciate any advises on how to diagnose the problem and/or identify
>> the source of error. Apart from that I'm wondering if this is a known
>> issue and how one can resolve it.
>
> Coupe quick thoughts on this:
>
> If a server doesn't respond, or network goes down, generally the linux
> cifs client will disconnect then reconnect automatically transparently
> and would be harmless but how and when the client does this has
> changed.
>
> Initially the cifs client was designed with the following reconnect logic:
>
> 1) For anything other than a file write request (or blocking lock
> request), if the server doesn't respond (respond within default
> timeout, which was well under a minute) then disconnect the socket and
> reconnect
> 2) For a write request use a much longer timeout, and for a write
> request beyond end of file (which could take hours if you picked a
> really big starting offset) would never time out.
>
> The logic was changed (after RHEL6, but the RedHat guys probably have
> backported it, at least to the most recent SP) to
> 1) if a request has taken more than about a 30 seconds then send an
> SMBEcho request.
> 2) if the server does not respond to a few echo requests then kill the
> tcp session and reconnect
>
> The advantage of the newer behavior (which was added a few years ago)
> is that it handles the case where a slow request (opening an offline
> file on tape drive for example) does not cause an otherwise healthy
> server to appear to be dead - so the chance of disconnecting to a
> "healthy" server goes way down since we won't disconnect from a server
> which is still responding to "SMBecho" requests.
>
> The workaround you pointed to of doing a cron job to periodically do
> something trivial on the mount prevents the server from
> autodisconnecting the socket (some servers autodisconnect inactive
> connections, with no active files) - although reconnecting should be
> harmless and transparent even in that case (except for cases where
> your kerberos credentials have expired and can't be reacquired or
> where password changed on the server)
> --
> Thanks,
>
> Steve
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
