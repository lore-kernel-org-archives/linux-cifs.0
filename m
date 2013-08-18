From: Marcus Moeller <marcus.moeller-OI3hZJvNYWs@public.gmane.org>
Subject: Re: DFS referrals
Date: Sun, 18 Aug 2013 17:26:37 +0200
Message-ID: <5210E7AD.1030408@gmx.ch>
References: <51DBD032.10305@gmx.ch> <20130709054702.15550964@tlielax.poochiereds.net> <51DBDDEA.9040702@gmx.ch> <20130709081027.450b1849@corrin.poochiereds.net> <51F664FB.5090507@gmx.ch> <20130729090759.62d15e2e@corrin.poochiereds.net> <51F6720C.3060500@gmx.ch> <20130729103445.6629cece@tlielax.poochiereds.net> <51F67EB0.40502@gmx.ch> <51F75300.9000703@gmx.ch> <51F7A513.1090806@gmx.ch> <20130730080116.76df98db@corrin.poochiereds.net> <51F7C67A.6020009@gmx.ch> <20130730101730.71549ec8@tlielax.poochiereds.net> <5209F598.1000101@gmx.ch> <CACyXjPyu+uKW5THRRimpJMLS35KFJRoi_Ck6QLqUP2LZ7nh1+w@mail.gmail.com> <20130813113210.649866dd@tlielax.poochiereds.net> <CACyXjPy69oa02aDp7ZLZx2WbJkXifxnp8yyfSHuBNSw5nBRTYw@mail.gmail.com> <20130818091011.7c2cc8b1@tlielax.poochiereds.net> <CACyXjPzY8bi_m7iJ52Rwv
 FNLYic+YyW_YenBmrirQmG0kS0Y9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACyXjPzY8bi_m7iJ52RwvFNLYic+YyW_YenBmrirQmG0kS0Y9g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Am 18.08.2013 17:14, schrieb Richard Sharpe:
> On Sun, Aug 18, 2013 at 6:10 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> On Sat, 17 Aug 2013 15:11:37 -0700
>> Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>>> On Tue, Aug 13, 2013 at 8:32 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>>> On Tue, 13 Aug 2013 08:00:14 -0700
>>>> Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>>>
>>>>> On Tue, Aug 13, 2013 at 2:00 AM, Marcus Moeller <marcus.moeller-OI3hZJvNYWs@public.gmane.org> wrote:
>>>>>> Hi again,
>>>>>>
>>>>>>>>>>>>>>> On Mon, 29 Jul 2013 14:50:03 +0200
>>>>>>>>>>>>>>> Marcus Moeller <marcus.moeller-OI3hZJvNYWs@public.gmane.org> wrote:
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> [  124.607810] fs/cifs/cifssmb.c: negprot rc 0
>>>>>>>>>>>>>>>> [  124.607814] fs/cifs/connect.c: Security Mode: 0xf
>>>>>>>>>>>>>>>> Capabilities:
>>>>>>>>>>>>>>>> 0x8001f3fc TimeAdjust: -7200
>>>>>>>>>>>>>>>> [  124.607817] fs/cifs/sess.c: sess setup type 4
>>>>>>>>>>>>>>>> [  124.607826] fs/cifs/cifs_spnego.c: key description =
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> ver=0x2;host=d.ethz.ch;ip4=82.130.70.6;sec=krb5;uid=0xaf05;creduid=0xaf05;user=mam4tst;pid=0x61a
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> [  124.803185] fs/cifs/sess.c: ssetup freeing small buf
>>>>>>>>>>>>>>>> ffff88022c31a000
>>>>>>>>>>>>>>>> [  124.803195] CIFS VFS: Send error in SessSetup = -126
>>>>>>>>>>>>>>>> [  124.803203] fs/cifs/connect.c: CIFS VFS: leaving
>>>>>>>>>>>>>>>> cifs_get_smb_ses (xid = 5) rc = -126
>>>>>>>>>>>>>>>> [  124.803212] fs/cifs/fscache.c:
>>>>>>>>>>>>>>>> cifs_fscache_release_client_cookie:
>>>>>>>>>>>>>>>> (0xffff88022a1b6000/0xffff88022a6430f0)
>>>>>>>>>>>>>>>> [  124.803368] fs/cifs/connect.c: CIFS VFS: leaving cifs_mount
>>>>>>>>>>>>>>>> (xid
>>>>>>>>>>>>>>>> = 4) rc = -126
>>>>>>>>>>>>>>>> [  124.803374] CIFS VFS: cifs_mount failed w/return code = -126
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> The only failure I see is the one above, and that's because it
>>>>>>>>>>>>>>> failed
>>>>>>>>>>>>>>> to upcall for the correct key. Are you sure you have krb5 creds as
>>>>>>>>>>>>>>> that
>>>>>>>>>>>>>>> user?
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Yes, creds are there and it also works when mounting from one of
>>>>>>>>>>>>>> the
>>>>>>>>>>>>>> servers directly.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Only mounting using the domainname does not work.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> [  131.324798] fs/cifs/cifssmb.c: negprot rc 0
>>>>>>>>>>>>>>>> [  131.324804] fs/cifs/connect.c: Security Mode: 0xf
>>>>>>>>>>>>>>>> Capabilities:
>>>>>>>>>>>>>>>> 0x8001f3fc TimeAdjust: -7200
>>>>>>>>>>>>>>>> [  131.324808] fs/cifs/sess.c: sess setup type 4
>>>>>>>>>>>>>>>> [  131.324821] fs/cifs/cifs_spnego.c: key description =
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> ver=0x2;host=d.ethz.ch;ip4=172.31.65.62;sec=krb5;uid=0xaf05;creduid=0xaf05;user=mam4tst;pid=0x62c
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>>>>>>> [  131.384335] fs/cifs/transport.c: For smb_command 115
>>>>>>>>>>>>>>>> [  131.384344] fs/cifs/transport.c: Sending smb: smb_len=1666
>>>>>>>>>>>>>>>> [  131.387043] fs/cifs/connect.c: RFC1002 header 0xf9
>>>>>>>>>>>>>>>> [  131.387055] fs/cifs/misc.c: checkSMB Length: 0xfd,
>>>>>>>>>>>>>>>> smb_buf_length: 0xf9
>>>>>>>>>>>>>>>> [  131.387095] fs/cifs/transport.c: cifs_sync_mid_result: cmd=115
>>>>>>>>>>>>>>>> mid=2 state=4
>>>>>>>>>>>>>>>> [  131.387100] fs/cifs/misc.c: Null buffer passed to
>>>>>>>>>>>>>>>> cifs_small_buf_release
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> Here' the upcall for a similar set of creds worked fine. The only
>>>>>>>>>>>>>>> thing
>>>>>>>>>>>>>>> that seems to have changed in the key description is the IP
>>>>>>>>>>>>>>> address.
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> Do you have cifs.upcall set up to use the --trust-dns flag? If so,
>>>>>>>>>>>>>>> why?
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> A relict from the past. I have removed it from the config. Thanks
>>>>>>>>>>>>>> for
>>>>>>>>>>>>>> pointing out.
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> Sorry, I was wrong. Without the -t option I am not even able to mount
>>>>>>>>>> it
>>>>>>>>>> at all. The man page states a few words on that parameter, but I am
>>>>>>>>>> still not sure how it works when -t is not set.
>>>>>>>>>>
>>>>>>>>>> With -t set, the initial problem with the domain lookup works, when
>>>>>>>>>> reverse DNS is configured propably.
>>>>>>>>>>
>>>>>>>>>
>>>>>>>>> Ok, that makes sense then. The problem here is that the kernel needs to
>>>>>>>>> know what service principal name to use when contacting the server, and
>>>>>>>>> I suspect your krb5 configuration is not quite right.
>>>>>>>>>
>>>>>>>>> It looks like you're doing something like:
>>>>>>>>>
>>>>>>>>>        mount //d.ethz.ch/dfs /mnt/dfs -o sec=krb5...
>>>>>>>>>
>>>>>>>>> ...at this point, what happens is that the kernel needs to get a krb5
>>>>>>>>> service ticket to talk to the CIFS service on the host.
>>>>>>>>>
>>>>>>>>> What it typically does is take the hostname in the UNC that you're
>>>>>>>>> trying to mount, prepend it with "cifs/" and then try to get a service
>>>>>>>>> ticket for that. In your case, it'll look something like this:
>>>>>>>>>
>>>>>>>>>        cifs/d.ethz.ch-ofn1FrHcITAsyahpCud6bTnlAmrJQu31@public.gmane.org
>>>>>>>>>
>>>>>>>>> ...now, typically if that fails, we'll give up. Trying to do anything
>>>>>>>>> else is not considered safe since it's vulernable to DNS spoofing.
>>>>>>>>>
>>>>>>>>> If however, you add the '-t' flag to cifs.upcall, that tells it to try
>>>>>>>>> and guess the hostname part of that principal by reverse resolving it in
>>>>>>>>> DNS. It takes the IP address to which you are connecting, does a
>>>>>>>>> reverse DNS lookup and then uses that in the SPN.
>>>>>>>>>
>>>>>>>>> This is less safe, since if your DNS server is compromised someone
>>>>>>>>> could redirect you to a malicious server, and your client wouldn't be
>>>>>>>>> able to trivially detect that. So it in effect waters down krb5
>>>>>>>>> security.
>>>>>>>>>
>>>>>>>>> The correct fix is to ensure that the server(s) to which you are
>>>>>>>>> connecting have the ability to accept SPNs for the "hostnames" to which
>>>>>>>>> you want to connect. That means that you need to add SPNs for
>>>>>>>>> cifs/d.ethz.ch and ensure that the server will accept them to talk to
>>>>>>>>> its cifs service.
>>>>>>>>>
>>>>>>>>> Alternately, you can continue to use the '-t' flag and ensure that each
>>>>>>>>> possible server accepts principals for the hostnames to which their IP
>>>>>>>>> addresses reverse-resolve, with the caveat that its less safe than
>>>>>>>>> doing that the "right way".
>>>>>>>>>
>>>>>>>>> As to how to add these principals and make the server accept them...it
>>>>>>>>> depends on the server.
>>>>>>>>>
>>>>>>>>> Clear as mud?
>>>>>>>>
>>>>>>>>
>>>>>>>> Hehe, thanks for pointing that out. One thing I am not yet aware of is
>>>>>>>> where the SPN cifs/d.ethz.ch has to be set? On the DFS Servers and/or on
>>>>>>>> the servers which hold the shares? The latter ones are EMC and the DFS
>>>>>>>> Servers are 2008R2.
>>>>>>>>
>>>>>>>> Greets
>>>>>>>> Marcus
>>>>>>>>
>>>>>>>
>>>>>>> Definitely on the first DFS server. On the others, they'll need to
>>>>>>> accept SPNs holding the hostnames that are in the DFS referrals. So if
>>>>>>> your DFS server gives you a referral that's something like this:
>>>>>>>
>>>>>>>       bar -> //foo.d.ethz.ch/bar
>>>>>>>
>>>>>>> ...then you'll need to ensure that foo.d.ethz.ch accepts SPNs that have
>>>>>>> that hostname in them.
>>>>>>
>>>>>>
>>>>>> I have found some time to talk to our Active Directory Admins. They
>>>>>> mentioned that every DC in our setup is a DFS server and there is nothing
>>>>>> like a 'first DFS'. So is it possible to set the same SPN on all of these
>>>>>> servers?
>>>>>
>>>>> No, it is not possible to set the same SPN on more than one computer
>>>>> object in AD.
>>>>>
>>>>> What happens here is a combination of DNS magic (there are multiple
>>>>> SRV records) and replication of the DFS info between DCs in the AD
>>>>> domain.
>>>>>
>>>>> A client can query any DC for the translation of a DNS namespace.
>>>>>
>>>>> My use case lives below that level and it is all pretty much working
>>>>> (except for XP, which will not do multiple levels of DFS referrals, it
>>>>> seems.)
>>>>>
>>>>> In any event, I might eventually have to use a shared secrets file,
>>>>> which overcomes the issue of SPNs.
>>>>>
>>>>
>>>> What SRV records are used? Should we fix mount.cifs to try and query
>>>> for an SRV record first and then try to resolve that hostname before
>>>> attempting to mount?
>>>
>>> Those are just for finding the namespace, and I am not sure exactly
>>> how it is handled, but if you have a namespace of
>>> \\domain.realm\namespace1, I think any DC in that domain can be used
>>> to get to the first level.
>>>
>>
>> Bear with me, as I'm pretty clueless as to how AD stuff works.
>>
>> If all I have is \\domain.realm\namespace1 what should I be doing to
>> connect to it at that point? Currently we just treat "domain.realm" as
>> a hostname, but evidently that's not quite the right thing to do. Is it?
>
> Let me check.
>
> It might be that Windows returns the IP addresses of all the DCs in
> that domain in that case (and, if Sites and Services has been set up
> properly, returns them with the closest ones to you first in the
> list.) That is, my mentioning of SRV records might be a red herring.
>
> In that case, if the first one fails, you should simply try the next
> one until you find one that responds.

Yes, that's how it works. It then tries to reverse lookup the ip address 
in order to mount the share. As our reverse DNS Setup is somewhat 
broken, that part fails. I thought that removing the -t option could be 
a workaround for that, but as the cifs/domain SPN can only be set on one 
DC, that's no option to.

Greets
Marcus
