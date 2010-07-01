From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [linux-cifs-client] Linux CIFS NTLMSSP mount failing against
	win2k8
Date: Thu, 1 Jul 2010 12:22:35 -0500
Message-ID: <AANLkTil7d6jny1qklx16KtopjjwpCPAw6jECBxmnCfKF@mail.gmail.com>
References: <20100410181730.7fa0af32@tlielax.poochiereds.net>
	<20100411064103.3ec408a1@tlielax.poochiereds.net>
	<m2u4a4634331004111242u2954f28fh4bd703922c9aa534@mail.gmail.com>
	<20100411194008.77aad10c@corrin.poochiereds.net>
	<1271199692.2518.19.camel@naomi.s4.naomi.abartlet.net>
	<20100414082944.3fc80df9@tlielax.poochiereds.net>
	<20100414113453.6a523b21@tlielax.poochiereds.net>
	<20100416224413.60b4566a@tlielax.poochiereds.net>
	<1271483903.28751.4.camel@naomi.s4.naomi.abartlet.net>
	<20100417062900.75e94f36@tlielax.poochiereds.net>
	<n2m4a4634331004210729u77f95ed6m329464437b5c3eeb@mail.gmail.com>
	<20100421161950.20fb979a@tlielax.poochiereds.net>
	<AANLkTime8fdm-Wbu2PT1rXw0edjzE1-4pTVJpHWcYUd0@mail.gmail.com>
	<1277767520.2276.41.camel@ruth>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Bartlett <abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1277767520.2276.41.camel@ruth>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Jun 28, 2010 at 6:25 PM, Andrew Bartlett <abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> w=
rote:
> On Mon, 2010-06-28 at 17:47 -0500, Shirish Pargaonkar wrote:
>
>> When I look at Windows - Windows smb2 traces, the (16 bytes) signatu=
re
>> looks nothing like
>> version (which is 1), ciphertext of 8 bytes of hmac-md5, sequence nu=
mber
>
> SMB2 SMB Signing does not use the NTLMSSP packet signing algorithm.
> Instead, like SMB, it takes the session key already calculated and
> applies a unique-to-SMB2 algorithm to it. =A0This involves sha256 I
> think.
>
> Andrew Bartlett
>
> --
> Andrew Bartlett =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0http://samba.org/~abartlet/
> Authentication Developer, Samba Team =A0 =A0 =A0 =A0 =A0 http://samba=
=2Eorg
> Samba Developer, Cisco Inc.
>


I have had luck with some kernel crypto apis while working on this code=
=2E
I have been able to use arc4 and md5 hash apis successfully while
not being able to figure out hmac-md5 apis and I had not even
looked at sha, which I will.

What is confusing to me is, current cifs code using ntlmv2 within
ntlmssp authenticates and signs against Windows 2003 server
successfully/

But it does not against Windows 7 and Windows 2008 (I do not have
a Windows Vista installation). I am currently changing to code and
I am sure I would be able to authenticate using ntlmv2 within ntlmssp.
singing is what is confusing.

With smb2 client also, I can authenticate against Windows 7 and
Windows 2008 but signing fails.

So I am confused about what algorithm to use for cifs to sign
against Windows 7 and Windows 2008 server for ntlmv2 within ntlmssp
and what algorithm to use for smb2 to sign against a Windows 7
and Windows 2008 server for ntlmv2 within ntlmssp.

I have been reading and following MS-NLMP and
http://davenport.sourceforge.net/ntlm.html
