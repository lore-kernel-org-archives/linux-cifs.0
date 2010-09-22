From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH -v6 3/4] cifs NTLMv2/NTLMSSP define crypto hash functions
 and create and send keys needed for key exchange
Date: Wed, 22 Sep 2010 16:10:39 -0500
Message-ID: <AANLkTi=a2-4TG=rUx-ojc7NOZ7TeFim9wGdOgm60yV_Y@mail.gmail.com>
References: <1284865355-16815-1-git-send-email-shirishpargaonkar@gmail.com>
	<20100921105254.32574ba4@corrin.poochiereds.net>
	<AANLkTimqjBtVyB+xvtv5F5_qs333XiFQm+S=8Gh20+x2@mail.gmail.com>
	<20100921114049.75ab2ee8@corrin.poochiereds.net>
	<AANLkTikxqyK72=QcBPu1h-CmpiC+pg5AhVj=V4JRBqS-@mail.gmail.com>
	<20100921164257.3d67598f@corrin.poochiereds.net>
	<AANLkTimOJLuBxDQHPZJAUxR3ieeErzUyzXwSP=VPO-+_@mail.gmail.com>
	<20100921200715.2a2d0b9e@corrin.poochiereds.net>
	<AANLkTinpO_pNz5JQTx9mRAE+HSaWeasMtmTzM6+OfE4Z@mail.gmail.com>
	<20100921204034.5cb9eca5@corrin.poochiereds.net>
	<AANLkTinU50DqmH_C74vS_N_U-EU9RN4DMtSMA9osA6v2@mail.gmail.com>
	<20100922135242.42e58426@corrin.poochiereds.net>
	<AANLkTimho+AT6-xGchORvDp1KxCaENfpmjGuZG=C0_u-@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimho+AT6-xGchORvDp1KxCaENfpmjGuZG=C0_u--JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Sep 22, 2010 at 3:58 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrot=
e:
>> Yep, that's correct. Note that the secType is a per-server parameter
>> right now.
>>
>> We could mix sectypes on a socket. I sent a patchset that did that t=
his
>> past spring, but Steve basically NAK'ed it.
>
> At least for the case of signing, =A0and for CIFS especially (where a=
ll
> users of the socket, use the 1st users credentials in signing) - it
> makes it less confusing. =A0 If we want to have different sectypes to
> the same user for different users we could still do it over different
> sockets (and with Ben's patch, different interfaces).
>
> --
> Thanks,
>
> Steve
>

OK. I will not touch that logic.  But I took out the function
match_security and I am able to
authenticate and sign in any order over the same smb connection using
session key
created and stored by the auth mech of the very first smb session on
that smb connection.

mount -t cifs //9.3.123.456/winshare2 /mnt/smb_e -o
sec=3Dntlmi,user=3Droot,pass=3D<passwd>
mount -t cifs //9.3.123456/winshare2 /mnt/smb_f -o
sec=3Dntlmsspi,user=3Droot,pass=3D<passwd>

or in reverse order.
