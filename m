From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [CIFS] Support for Minshall+French symlinks
Date: Tue, 3 Aug 2010 13:00:00 -0500
Message-ID: <AANLkTinJ1WRBT_Q3TqOZdMQExV66LSUAPG4c01yK-XRK@mail.gmail.com>
References: <1280847960-16371-1-git-send-email-metze@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1280847960-16371-1-git-send-email-metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Interesting.

Generally seems like a good idea.

Jeff made two valid review comments already (on the kmalloc vs. stack,
and the kernel coding style) but note that scripts/checkpatch.pl will
catch additional minor coding style things:

stevef@stevef-laptop:~/smb2$ scripts/checkpatch.pl ~/sm1.patch
WARNING: braces {} are not necessary for single statement blocks
#62: FILE: fs/cifs/link.c:120:
+	if (rc != 0) {
+		return rc;
+	}

Could you clean up the things scripts/checkpatch.pl (and sparse
issues, ie "make modules C=1"  -- if any)

On Tue, Aug 3, 2010 at 10:05 AM, Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> Hi Steve,
>
> The following patchset adds support Minshall+French symlinks for Linux.
> See http://wiki.samba.org/index.php/UNIX_Extensions#Minshall.2BFrench_symlinks
>
> I've added a new mount option 'mfsymlinks', which is off by default.
>
> If the option is pass to a mount, Minshall+French symlinks will be used
> to support symlinks for the local client.
>
> This is compatible with the Darwin implementation.
>
> Can you review this patches? It would be wonderful if they would endup
> in Linux 2.6.36.
>
> metze
>
>



-- 
Thanks,

Steve
