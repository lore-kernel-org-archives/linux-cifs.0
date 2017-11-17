From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] cifs: fix return code when failing to rename a file onto a directory
Date: Fri, 17 Nov 2017 16:10:40 +0100
Message-ID: <mpsshddos9b.fsf@aaptelpc.suse.de>
References: <20171109235249.8013-1-lsahlber@redhat.com> <CAKywueStf29fgZ-52ONqL+WLSYotaVwMpsqnu2gQdppuw5xtoA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueStf29fgZ-52ONqL+WLSYotaVwMpsqnu2gQdppuw5xtoA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
>
> What if the target is directory but the permissions are read-only?

I get the same resulsts on a local filesystem (xfs) and on a mounted
smb2 windows2016 share (both with and without the patch applied):

overwrite dir b with file a (with access to b)
=======================
rename("test/a", "test/b")              = -1 EISDIR (Is a directory)

overwrite dir b with file a (without access to b)
=======================
rename("test/a", "test/b")              = -1 EISDIR (Is a directory)

overwrite file b with file a (with access to b)
=======================
rename("test/a", "test/b")              = 0

overwrite file b with file a (without access to b)
=======================
rename("test/a", "test/b")              = 0

So.. I'm not sure what the xfstest test is doing.

The only difference between the local and remote fs is that for cifs you
can't delete test if you can't access test/b. (I am deleting "test"
between my tests).

That is on cifs:

  mkdir -p test/b
  chmod a-rw test/b
  rm -rf test

Will fail, but works on xfs. You you strace rm you will see:

  unlinkat(4, "b", AT_REMOVEDIR) = -1 EACCES (Permission denied)

I think this is due to the fundamental difference in how file removal
permission works in Windows vs POSIX. In POSIX you need +w on the parent
dir ("test") to be able to delete a file. On Windows there is a special
delete permission on the object itself. Not sure if this is "fixable".

Cheers,

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
