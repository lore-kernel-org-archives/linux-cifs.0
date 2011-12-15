From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 00/12] cifscreds: cleanup and overhaul of cifscreds utility
Date: Thu, 15 Dec 2011 12:32:46 -0600
Message-ID: <CADT32eJ3vtbcDLmtNVEq0CNyrq-qZSark_xfv=xZfsFwSPM=6g@mail.gmail.com>
References: <1323972736-15804-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1323972736-15804-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Dec 15, 2011 at 12:12 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote=
:
> This patchset is a cleanup and overhaul of the cifscreds utility that
> lives in the cifs-utils tree today. Igor Druzhinin did a wonderful jo=
b
> on this when he did the original code a couple of years ago, but I di=
d a
> rather poor job at the time of communicating what we actually need fo=
r
> this tool to do. Mea culpa...
>
> This patch is a second pass at morphing it into a tool that's more li=
ke
> what we need. I believe with this, I'll be able to roll some kernel
> patches that can use the stashed key for establishing sessions.
>
> I've made a few changes since the last set:
>
> - combine some of the earlier patches so it's a smaller set
>
> - I've dropped the patch to make key_search use keyctl_search. I'd st=
ill
> =A0like to do this differently, but for now it's not possible to do s=
o
> =A0and protect the key payload
>
> The idea here is that we want to be able to allow users to stash thei=
r
> NTLM credentials in the kernel, so that it's possible to establish a
> session on the fly when that user walks into a multiuser mount.
>
> To that end, there are a number of changes that I'm proposing:
>
> - a number of structural cleanups that may make this code more amenab=
le
> =A0to conversion to a library later and that make it easier to mainta=
in
>
> - hang these off of the session keyring instead of the uid keyring. I
> =A0believe this will make this more friendly for use in containers an=
d
> =A0may make it harder to compromise the user's password.
>
> - instead of having the domain as an optional parameter, allow the us=
er
> =A0to specify it in lieu of the hostname. During session setup, the k=
ernel can
> =A0first look for a host-specific key, and then fall back to looking =
for
> =A0one that matches the domain if a host key isn't found.
>
> There are still some things that need to be done to make this really
> usable:
>
> - a manpage
>
> - kernel patches that can make these keys usable
>
> Comments and suggestions welcome...
>
> Jeff Layton (12):
> =A0util: move getusername to util.c
> =A0cifscreds: add unused attribute to argv parm in cifscreds_clearall
> =A0cifscreds: eliminate domain parm from most functions
> =A0cifscreds: remove user parameter from create_description
> =A0cifscreds: make username part of value instead of description
> =A0cifscreds: make usage use "return" and have callers return
> =A0cifscreds: move option parsing into main()
> =A0cifscreds: make username parameter optional
> =A0cifscreds: add --domain flag
> =A0cifscreds: loosen allowed characters in domain names
> =A0cifscreds: use the session keyring
> =A0cifscreds: further restrict permissions on keys
>
> =A0cifscreds.c =A0| =A0257 +++++++++++++++++++++++++++++-------------=
----------------
> =A0mount.cifs.c | =A0 11 ---
> =A0util.c =A0 =A0 =A0 | =A0 13 +++
> =A0util.h =A0 =A0 =A0 | =A0 =A01 +
> =A04 files changed, 141 insertions(+), 141 deletions(-)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html

Will there be a utility like smbpasswd as part of cifs-utils package?
