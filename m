From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cifs unable to access shares with read restricted at root level (bso#8950)
Date: Mon, 26 Oct 2015 22:04:28 -0500
Message-ID: <CADT32eJgrjigh_ezCAJK-ivO-t_yygPEhgwoHKsE-8EdVxKP+Q@mail.gmail.com>
References: <20151026131817.3a8a3ded@aaptelpc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151026131817.3a8a3ded@aaptelpc>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Oct 26, 2015 at 7:18 AM, Aur=C3=A9lien Aptel <aaptel-IBi9RG/b67k@public.gmane.org> =
wrote:
> Hi!
>
> I've recently started working on bso#8950 [1] but I'm both a
> kernel/SMB protocol newbie so bear with me... :-)
>
> Shirish Pargaonkar provided a fix but it doesn't work on my setup. I
> would like to provide a fix for SUSE even if temporary/hacky. Shirish=
's
> approach seems sound so I've tried debugging it. I've summarized the
> situation and my comments here [2].
>
> There are a few things I don't understand yet.
>
> * Where are disconnected dentries stored?

They are stored in a linked list of struct cifs_rdelem off of
superblock where each element of this linked list points to a
disconnected dentry.

> * How do you allocate a new dentry?
> * What do d_obtain_alias() and d_splice_dentry() actually do? I've re=
ad
>   the doc strings several times but I still have a hard time wrapping=
 my
>   head around it.

I think the simplistic answer is d_obtain_alias creates a dentry withou=
t
a parent and d_splice_dentry connects a disconnected dentry to a parent=
=2E
So let us say you have a a filesystem like /a/b/c/d/e/f where c is
not accessible, we would create a disconnected for d (and for all the
entries starting d such as e and f)
Then when c is accessible and we are trying to reach f, while
traversing, for each dentry we would look whether it is disconnected
or not and if found (by any of three search routines), splice dentry wi=
th
c.

What kind of setup do you have where the patchset is not working?

>
> The result I'm getting seems to indicate that when an intermediary pa=
th
> element is inaccessible an alternate root dentry directly pointing to
> the requested path is created. The problem is that the prefixpath of
> that is not stored anywhere so when we ask for a pattern to list the
> content of that share, we use the path of the dentry from the root
> (which is, well /) instead of the share prefixpath.
>
> 1: https://bugzilla.samba.org/show_bug.cgi?id=3D8950
> 2: http://diobla.info/doc/suse-todo#bnc799133
>
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Linux GmbH, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany
> GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton, HRB 21284 (=
AG
> N=C3=BCrnberg)
