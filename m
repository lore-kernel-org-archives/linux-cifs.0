From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v1] cifs: make shares unaccessible at root level mountable
Date: Mon, 16 Nov 2015 23:20:09 -0600
Message-ID: <CADT32eJ_uLj4_sEhWc+O=xjOMMfNhGGH9XhiJmdDQyrL6Dzp3A@mail.gmail.com>
References: <20151105154836.1851c30c@aaptelpc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151105154836.1851c30c@aaptelpc>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I do not understand why you need to entertain error ENOENT on an
intermediate path.
If a server is returning that error, there does not exist such an entry=
=2E
In such a case, does Query Path Info on the full path return any error?

I still do not understand why noserverino is in picture. Only the
disconnected root dentry
has an inode generated with an id by the cifs client.  Once this
disconnected root denty
gets spliced, the inode is filled with correct inode (fileid)
available from the server
(since that intermediate path is now accessible hence splicable).
You have fileid/inode available for all eligible/accessible file
objects under the disconnected
root entry.


On Thu, Nov 5, 2015 at 8:48 AM, Aur=C3=A9lien Aptel <aaptel-IBi9RG/b67k@public.gmane.org> w=
rote:
> Hi,
>
> I've been working on solving this bug [1] for some time now. You can
> find some of my research notes here [2]. I was recently able to
> finally make it work.
>
> The patch is based on Shirish's patch (available at [1]) to which I'v=
e
> made the following modification:
>
> - create disconnected root when any intermediary path are "not
>   found" (ENOENT). Previously it was only done for EACCES errors.
>
> - fix build_path_from_dentry() to correctly prefix dentry that are
>   children of a disconnected root with the disconnected root actual
>   path. This path is only avaible when using the struct rdelem linked
>   list stored in the cifs superblock i.e. when we mount with
>   noserverino.
>
> So basically if you have the bug described in [1] you can solve it by
> applying this patch and mounting with -o noserverino. I would like to
> get rid this restriction (noserverino) and unconditionnaly use the
> rdelem linked list but I don't know how feasible/safe that is (I'm st=
ill
> new to all this stuff, this is my first kernel patch).
>
> Shirish, I'd like to hear your comments if you have any. I've noticed
> your find_rdelem_by_dentry() removes the dentry from the rdelem list
> and I'm not sure I understand why. I've added and used
> find_rdelem_by_dentry_no_del() to do the same thing without removing =
it.
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
