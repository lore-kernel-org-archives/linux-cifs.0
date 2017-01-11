From: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] SMB2: Enforce sec= mount option
Date: Wed, 11 Jan 2017 11:48:16 -0600
Message-ID: <CAFB9KM0VVe+wjkiu=t1_JjFg6C+VcMHS-ubvgLQ-UyjzSKzmBQ@mail.gmail.com>
References: <1481179577-15995-1-git-send-email-sprabhu@redhat.com>
 <CAFB9KM0oPPm4bYyKd75Yjy-2kCZ=0UTpwn=ONCRo0g5waNa6AA@mail.gmail.com>
 <1481187800.4195.19.camel@redhat.com> <c0748fb1-4161-ea0f-3f6d-b0705bb83a9d@citrix.com>
 <1484137071.29387.9.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: Germano Percossi <germano.percossi-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1484137071.29387.9.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Jan 11, 2017 at 6:17 AM, Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
[snip]
> My own opinion is that when a mount option is explicitly passed, it is
> expected the option provided be used and fail if it cannot be used. I
> think replacing a explicitly requested mount option with another can
> lead to unexpected results and may also affect things activities like
> testing.
>
> There are other mount options like "vers=3D" where cifs doesn't attempt
> to replace an invalid protocol version with another. This in my opinion
> is the correct behaviour.

Allow me to play Devil's advocate, but with a bridge we'll have to
cross if we enact this behavior... Quoth The (current-ish) Fine Manual
page for mount.cifs (quoted in full for historical mail list
reference) :
"
    sec=3D
           Security mode. Allowed values are:

           =C2=B7   none - attempt to connection as a null user (no name)
           =C2=B7   krb5 - Use Kerberos version 5 authentication
           =C2=B7   krb5i - Use Kerberos authentication and forcibly enable
packet signing
           =C2=B7   ntlm - Use NTLM password hashing
           =C2=B7   ntlmi - Use NTLM password hashing and force packet sign=
ing
           =C2=B7   ntlmv2 - Use NTLMv2 password hashing
           =C2=B7   ntlmv2i - Use NTLMv2 password hashing and force packet =
signing
           =C2=B7   ntlmssp - Use NTLMv2 password hashing encapsulated in
Raw NTLMSSP message
           =C2=B7   ntlmsspi - Use NTLMv2 password hashing encapsulated in
Raw NTLMSSP message, and force packet signing
           The default in mainline kernel versions prior to v3.8 was
sec=3Dntlm. In v3.8, the default was changed to sec=3Dntlmssp.

           If the server requires signing during protocol negotiation,
then it may be enabled automatically. Packet signing may also be
enabled
           automatically if it's enabled in /proc/fs/cifs/SecurityFlags.
"

What is the defined behavior if I specify that I'd like any of the
more current NTLM variants kerberos-5, explicitly, without packet
signing but the server requires packet signing?  Currently, we
silently turn it on.  Is the defined behavior to now loudly fail
rather than enable signing?  Especially since the default value
changed in Linux-3.8.  I'd argue that we already somewhat treat the
"sec" option as a preference rather than a requirement.  I would
further argue, although not strongly, that if we want to go down this
road, that we should accept multiple options and if NONE of them can
be used, then we fail.  Does anyone have a better idea, or is the
consensus that this isn't as large of an issue (both technologically
and from a user perspective) as I perceive it to be?

Steve, I'll defer to you as well with my objection above noted.
