From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: allow calling	cifs_build_path_to_root on
 incomplete cifs_sb
Date: Wed, 16 Feb 2011 07:25:07 -0500
Message-ID: <20110216072507.49b65c9d@tlielax.poochiereds.net>
References: <20101206070846.1f2c35d4@tlielax.poochiereds.net>
	<1291637583-10934-1-git-send-email-jlayton@redhat.com>
	<4D5B8941.8040800@computer.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	"robbert-C1IQQP51G3M@public.gmane.org" <robbert-C1IQQP51G3M@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Darren Williams <darren.w-bdq14YP6qtRg9hUCZPvPmw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D5B8941.8040800-bdq14YP6qtRg9hUCZPvPmw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 16 Feb 2011 19:22:25 +1100
Darren Williams <darren.w-bdq14YP6qtRg9hUCZPvPmw@public.gmane.org> wrote:

> Hi All
> 
> Robert and Jeff thanks for working on and fixing this, I can confirm 
> that we now have;
> - Remote DFS mounts working, using
> - both sec=krb5 and sec=ntlm.
> 
> I'm just looking for clarification on the following feature or bug:
> 
> we have a SAMBA server, samba1, serving a DFS root as follows
> 
> [dfs]
>     path = /export/samba/dfs
>     msdfs root = yes
> 
> configured as:
> 
> ls -l /export/samba/dfs
> total 8
> lrwxrwxrwx 1 root root 79 2010-03-10 07:53 home -> 
> msdfs:samba1\dfshome,samba2\dfshome
> 
> and SAMBA servers, samba1 and samba2 with shares:
> 
> [dfshome]
>     comment = DFS Linux Home Directories
>     path = /export/home/1/%u
>     create mask = 0700
>     force create mode = 0700
>     directory mask = 0700
>     force directory mode = 0700
>     read only = No
>     browseable = No
>     valid users = %U
>     map acl inherit = yes
> 
> 
> 
> If I cifs mount the DFS root using
> mount.cifs //samba1/dfs /tmp/dfs -o <options as required>
> then list the directory I get the following errors:
> 
> 
> root@atp-h5gcn1s:~# mount.cifs //samba1/dfs /tmp/dfs/ -o <options>
> Password:
> root@atp-h5gcn1s:~# ls -l /tmp/dfs/
> ls: cannot read symbolic link /tmp/dfs/home: Object is remote
> ls: cannot read symbolic link /tmp/dfs/test-home: Object is remote
> ls: cannot read symbolic link /tmp/dfs/projects: Object is remote
> total 8
> lrwxrwxrwx 1 root root 79 Mar 10  2010 home
> lrwxrwxrwx 1 root root 46 Mar 10  2010 projects
> lrwxrwxrwx 1 root root 79 Mar 25  2010 test-home
> root@atp-h5gcn1s:~# ls -l /tmp/dfs/home/
> ls: cannot access /tmp/dfs/home/: Not a directory
> root@atp-h5gcn1s:~# umount /tmp/dfs
> 
> I then remount and access a file in 'home' directly, which then allows 
> the directory listing to succeed.
> 
> root@atp-h5gcn1s:~# mount.cifs //samba1/dfs /tmp/dfs/ -o 
> user=dwilliams,dom=NICTA
> Password:
> root@atp-h5gcn1s:~# ls -l /tmp/dfs/home/.bashrc
> -rw-r--r-- 1 <user> <group> 2450 Jun  8  2008 /tmp/dfs/home/.bashrc
> root@atp-h5gcn1s:~# ls  /tmp/dfs/
> home  projects    test-home
> root@atp-h5gcn1s:~# ls -l /tmp/dfs/home/
> -rw-r--r--  1 <user> <group>     3078 Aug 17  2007 2007-08-17-P.....
> ....
> 
> also access is OK if you mount 'home' directly via dfs
> 
> root@atp-h5gcn1s:~# mount.cifs //samba1/dfs/home /tmp/dfs/ -o <options>
> 
> I'm looking for clarification on what the correct operation should be 
> since our Windows clients can access the root the traverse the directory 
> tree without error, not that this is evidence for correct operation.
> 

I believe that's a bug...

The way things like autofs, DFS referrals and NFS used to work is by
pretending these mountpoints are symlinks and then abusing the
->follow_link operation on them in the kernel. Not all operations on
that inode trigger the follow_link op however, so sometimes -EREMOTE
errors bubble up when they shouldn't. Either that or we just have some
straightforward bad handling of -EREMOTE errors in the readdir codepath
-- I'm not sure yet :)

What may be best is to open a bug at bugzilla.samba.org and we'll chase
it down when we get a chance. If you do that, please cc me on it. FWIW,
I opened this bug a while back which is probably related, but haven't
had time to work on it:

    https://bugzilla.redhat.com/show_bug.cgi?id=616765

This may also be helped by the d_automount patches that dhowells did
recently and that are going into 2.6.38, but I haven't had time to look
yet.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
