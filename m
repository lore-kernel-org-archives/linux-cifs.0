From: Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: DFS referrals
Date: Sun, 18 Aug 2013 08:14:20 -0700
Message-ID: <CACyXjPzY8bi_m7iJ52RwvFNLYic+YyW_YenBmrirQmG0kS0Y9g@mail.gmail.com>
References: <51DBD032.10305@gmx.ch>
	<20130709054702.15550964@tlielax.poochiereds.net>
	<51DBDDEA.9040702@gmx.ch>
	<20130709081027.450b1849@corrin.poochiereds.net>
	<51F664FB.5090507@gmx.ch>
	<20130729090759.62d15e2e@corrin.poochiereds.net>
	<51F6720C.3060500@gmx.ch>
	<20130729103445.6629cece@tlielax.poochiereds.net>
	<51F67EB0.40502@gmx.ch>
	<51F75300.9000703@gmx.ch>
	<51F7A513.1090806@gmx.ch>
	<20130730080116.76df98db@corrin.poochiereds.net>
	<51F7C67A.6020009@gmx.ch>
	<20130730101730.71549ec8@tlielax.poochiereds.net>
	<5209F598.1000101@gmx.ch>
	<CACyXjPyu+uKW5THRRimpJMLS35KFJRoi_Ck6QLqUP2LZ7nh1+w@mail.gmail.com>
	<20130813113210.649866dd@tlielax.poochiereds.net>
	<CACyXjPy69oa02aDp7ZLZx2WbJkXifxnp8yyfSHuBNSw5nBRTYw@mail.gmail.com>
	<20130818091011.7c2cc8b1@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Marcus Moeller <marcus.moeller-OI3hZJvNYWs@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130818091011.7c2cc8b1-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, Aug 18, 2013 at 6:10 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Sat, 17 Aug 2013 15:11:37 -0700
> Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Tue, Aug 13, 2013 at 8:32 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
>> > On Tue, 13 Aug 2013 08:00:14 -0700
>> > Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >
>> >> On Tue, Aug 13, 2013 at 2:00 AM, Marcus Moeller <marcus.moeller@g=
mx.ch> wrote:
>> >> > Hi again,
>> >> >
>> >> >>>>>>>>>> On Mon, 29 Jul 2013 14:50:03 +0200
>> >> >>>>>>>>>> Marcus Moeller <marcus.moeller-OI3hZJvNYWs@public.gmane.org> wrote:
>> >> >>>>>>>>>>
>> >> >>>>>>>>>>> [  124.607810] fs/cifs/cifssmb.c: negprot rc 0
>> >> >>>>>>>>>>> [  124.607814] fs/cifs/connect.c: Security Mode: 0xf
>> >> >>>>>>>>>>> Capabilities:
>> >> >>>>>>>>>>> 0x8001f3fc TimeAdjust: -7200
>> >> >>>>>>>>>>> [  124.607817] fs/cifs/sess.c: sess setup type 4
>> >> >>>>>>>>>>> [  124.607826] fs/cifs/cifs_spnego.c: key description=
 =3D
>> >> >>>>>>>>>>>
>> >> >>>>>>>>>>> ver=3D0x2;host=3Dd.ethz.ch;ip4=3D82.130.70.6;sec=3Dkr=
b5;uid=3D0xaf05;creduid=3D0xaf05;user=3Dmam4tst;pid=3D0x61a
>> >> >>>>>>>>>>>
>> >> >>>>>>>>>>>
>> >> >>>>>>>>>>> [  124.803185] fs/cifs/sess.c: ssetup freeing small b=
uf
>> >> >>>>>>>>>>> ffff88022c31a000
>> >> >>>>>>>>>>> [  124.803195] CIFS VFS: Send error in SessSetup =3D =
-126
>> >> >>>>>>>>>>> [  124.803203] fs/cifs/connect.c: CIFS VFS: leaving
>> >> >>>>>>>>>>> cifs_get_smb_ses (xid =3D 5) rc =3D -126
>> >> >>>>>>>>>>> [  124.803212] fs/cifs/fscache.c:
>> >> >>>>>>>>>>> cifs_fscache_release_client_cookie:
>> >> >>>>>>>>>>> (0xffff88022a1b6000/0xffff88022a6430f0)
>> >> >>>>>>>>>>> [  124.803368] fs/cifs/connect.c: CIFS VFS: leaving c=
ifs_mount
>> >> >>>>>>>>>>> (xid
>> >> >>>>>>>>>>> =3D 4) rc =3D -126
>> >> >>>>>>>>>>> [  124.803374] CIFS VFS: cifs_mount failed w/return c=
ode =3D -126
>> >> >>>>>>>>>>
>> >> >>>>>>>>>>
>> >> >>>>>>>>>> The only failure I see is the one above, and that's be=
cause it
>> >> >>>>>>>>>> failed
>> >> >>>>>>>>>> to upcall for the correct key. Are you sure you have k=
rb5 creds as
>> >> >>>>>>>>>> that
>> >> >>>>>>>>>> user?
>> >> >>>>>>>>>
>> >> >>>>>>>>>
>> >> >>>>>>>>> Yes, creds are there and it also works when mounting fr=
om one of
>> >> >>>>>>>>> the
>> >> >>>>>>>>> servers directly.
>> >> >>>>>>>>>
>> >> >>>>>>>>> Only mounting using the domainname does not work.
>> >> >>>>>>>>>
>> >> >>>>>>>>>
>> >> >>>>>>>>>>> [  131.324798] fs/cifs/cifssmb.c: negprot rc 0
>> >> >>>>>>>>>>> [  131.324804] fs/cifs/connect.c: Security Mode: 0xf
>> >> >>>>>>>>>>> Capabilities:
>> >> >>>>>>>>>>> 0x8001f3fc TimeAdjust: -7200
>> >> >>>>>>>>>>> [  131.324808] fs/cifs/sess.c: sess setup type 4
>> >> >>>>>>>>>>> [  131.324821] fs/cifs/cifs_spnego.c: key description=
 =3D
>> >> >>>>>>>>>>>
>> >> >>>>>>>>>>> ver=3D0x2;host=3Dd.ethz.ch;ip4=3D172.31.65.62;sec=3Dk=
rb5;uid=3D0xaf05;creduid=3D0xaf05;user=3Dmam4tst;pid=3D0x62c
>> >> >>>>>
>> >> >>>>>
>> >> >>>>>>>>>>> [  131.384335] fs/cifs/transport.c: For smb_command 1=
15
>> >> >>>>>>>>>>> [  131.384344] fs/cifs/transport.c: Sending smb: smb_=
len=3D1666
>> >> >>>>>>>>>>> [  131.387043] fs/cifs/connect.c: RFC1002 header 0xf9
>> >> >>>>>>>>>>> [  131.387055] fs/cifs/misc.c: checkSMB Length: 0xfd,
>> >> >>>>>>>>>>> smb_buf_length: 0xf9
>> >> >>>>>>>>>>> [  131.387095] fs/cifs/transport.c: cifs_sync_mid_res=
ult: cmd=3D115
>> >> >>>>>>>>>>> mid=3D2 state=3D4
>> >> >>>>>>>>>>> [  131.387100] fs/cifs/misc.c: Null buffer passed to
>> >> >>>>>>>>>>> cifs_small_buf_release
>> >> >>>>>>>>>>
>> >> >>>>>>>>>>
>> >> >>>>>>>>>> Here' the upcall for a similar set of creds worked fin=
e. The only
>> >> >>>>>>>>>> thing
>> >> >>>>>>>>>> that seems to have changed in the key description is t=
he IP
>> >> >>>>>>>>>> address.
>> >> >>>>>>>>>>
>> >> >>>>>>>>>> Do you have cifs.upcall set up to use the --trust-dns =
flag? If so,
>> >> >>>>>>>>>> why?
>> >> >>>>>>>>>
>> >> >>>>>>>>>
>> >> >>>>>>>>> A relict from the past. I have removed it from the conf=
ig. Thanks
>> >> >>>>>>>>> for
>> >> >>>>>>>>> pointing out.
>> >> >>>>>
>> >> >>>>>
>> >> >>>>> Sorry, I was wrong. Without the -t option I am not even abl=
e to mount
>> >> >>>>> it
>> >> >>>>> at all. The man page states a few words on that parameter, =
but I am
>> >> >>>>> still not sure how it works when -t is not set.
>> >> >>>>>
>> >> >>>>> With -t set, the initial problem with the domain lookup wor=
ks, when
>> >> >>>>> reverse DNS is configured propably.
>> >> >>>>>
>> >> >>>>
>> >> >>>> Ok, that makes sense then. The problem here is that the kern=
el needs to
>> >> >>>> know what service principal name to use when contacting the =
server, and
>> >> >>>> I suspect your krb5 configuration is not quite right.
>> >> >>>>
>> >> >>>> It looks like you're doing something like:
>> >> >>>>
>> >> >>>>       mount //d.ethz.ch/dfs /mnt/dfs -o sec=3Dkrb5...
>> >> >>>>
>> >> >>>> ...at this point, what happens is that the kernel needs to g=
et a krb5
>> >> >>>> service ticket to talk to the CIFS service on the host.
>> >> >>>>
>> >> >>>> What it typically does is take the hostname in the UNC that =
you're
>> >> >>>> trying to mount, prepend it with "cifs/" and then try to get=
 a service
>> >> >>>> ticket for that. In your case, it'll look something like thi=
s:
>> >> >>>>
>> >> >>>>       cifs/d.ethz.ch-ofn1FrHcITAsyahpCud6bTnlAmrJQu31@public.gmane.org
>> >> >>>>
>> >> >>>> ...now, typically if that fails, we'll give up. Trying to do=
 anything
>> >> >>>> else is not considered safe since it's vulernable to DNS spo=
ofing.
>> >> >>>>
>> >> >>>> If however, you add the '-t' flag to cifs.upcall, that tells=
 it to try
>> >> >>>> and guess the hostname part of that principal by reverse res=
olving it in
>> >> >>>> DNS. It takes the IP address to which you are connecting, do=
es a
>> >> >>>> reverse DNS lookup and then uses that in the SPN.
>> >> >>>>
>> >> >>>> This is less safe, since if your DNS server is compromised s=
omeone
>> >> >>>> could redirect you to a malicious server, and your client wo=
uldn't be
>> >> >>>> able to trivially detect that. So it in effect waters down k=
rb5
>> >> >>>> security.
>> >> >>>>
>> >> >>>> The correct fix is to ensure that the server(s) to which you=
 are
>> >> >>>> connecting have the ability to accept SPNs for the "hostname=
s" to which
>> >> >>>> you want to connect. That means that you need to add SPNs fo=
r
>> >> >>>> cifs/d.ethz.ch and ensure that the server will accept them t=
o talk to
>> >> >>>> its cifs service.
>> >> >>>>
>> >> >>>> Alternately, you can continue to use the '-t' flag and ensur=
e that each
>> >> >>>> possible server accepts principals for the hostnames to whic=
h their IP
>> >> >>>> addresses reverse-resolve, with the caveat that its less saf=
e than
>> >> >>>> doing that the "right way".
>> >> >>>>
>> >> >>>> As to how to add these principals and make the server accept=
 them...it
>> >> >>>> depends on the server.
>> >> >>>>
>> >> >>>> Clear as mud?
>> >> >>>
>> >> >>>
>> >> >>> Hehe, thanks for pointing that out. One thing I am not yet aw=
are of is
>> >> >>> where the SPN cifs/d.ethz.ch has to be set? On the DFS Server=
s and/or on
>> >> >>> the servers which hold the shares? The latter ones are EMC an=
d the DFS
>> >> >>> Servers are 2008R2.
>> >> >>>
>> >> >>> Greets
>> >> >>> Marcus
>> >> >>>
>> >> >>
>> >> >> Definitely on the first DFS server. On the others, they'll nee=
d to
>> >> >> accept SPNs holding the hostnames that are in the DFS referral=
s. So if
>> >> >> your DFS server gives you a referral that's something like thi=
s:
>> >> >>
>> >> >>      bar -> //foo.d.ethz.ch/bar
>> >> >>
>> >> >> ...then you'll need to ensure that foo.d.ethz.ch accepts SPNs =
that have
>> >> >> that hostname in them.
>> >> >
>> >> >
>> >> > I have found some time to talk to our Active Directory Admins. =
They
>> >> > mentioned that every DC in our setup is a DFS server and there =
is nothing
>> >> > like a 'first DFS'. So is it possible to set the same SPN on al=
l of these
>> >> > servers?
>> >>
>> >> No, it is not possible to set the same SPN on more than one compu=
ter
>> >> object in AD.
>> >>
>> >> What happens here is a combination of DNS magic (there are multip=
le
>> >> SRV records) and replication of the DFS info between DCs in the A=
D
>> >> domain.
>> >>
>> >> A client can query any DC for the translation of a DNS namespace.
>> >>
>> >> My use case lives below that level and it is all pretty much work=
ing
>> >> (except for XP, which will not do multiple levels of DFS referral=
s, it
>> >> seems.)
>> >>
>> >> In any event, I might eventually have to use a shared secrets fil=
e,
>> >> which overcomes the issue of SPNs.
>> >>
>> >
>> > What SRV records are used? Should we fix mount.cifs to try and que=
ry
>> > for an SRV record first and then try to resolve that hostname befo=
re
>> > attempting to mount?
>>
>> Those are just for finding the namespace, and I am not sure exactly
>> how it is handled, but if you have a namespace of
>> \\domain.realm\namespace1, I think any DC in that domain can be used
>> to get to the first level.
>>
>
> Bear with me, as I'm pretty clueless as to how AD stuff works.
>
> If all I have is \\domain.realm\namespace1 what should I be doing to
> connect to it at that point? Currently we just treat "domain.realm" a=
s
> a hostname, but evidently that's not quite the right thing to do. Is =
it?

Let me check.

It might be that Windows returns the IP addresses of all the DCs in
that domain in that case (and, if Sites and Services has been set up
properly, returns them with the closest ones to you first in the
list.) That is, my mentioning of SRV records might be a red herring.

In that case, if the first one fails, you should simply try the next
one until you find one that responds.

--=20
Regards,
Richard Sharpe
(=E4=BD=95=E4=BB=A5=E8=A7=A3=E6=86=82=EF=BC=9F=E5=94=AF=E6=9C=89=E6=9D=9C=
=E5=BA=B7=E3=80=82--=E6=9B=B9=E6=93=8D)
