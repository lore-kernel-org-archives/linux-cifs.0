From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Is that possible follow symbol link location which point with
 full location
Date: Mon, 29 Aug 2016 09:54:23 -0500
Message-ID: <CAH2r5msULOWU0E3zL9zH+d_zhEngof5Htfn-D1JgDYa4PJsrsg@mail.gmail.com>
References: <CAOXDmPr9tgNVQFJOpurtfH6+C3gRa5nej=uKpzXmvHY6m6d6hw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Cong Monkey <congzhangzh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOXDmPr9tgNVQFJOpurtfH6+C3gRa5nej=uKpzXmvHY6m6d6hw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If you want to create a symbolic link with a target of UNC name
("\\server\share\path") instead of "path" you should configure it as a
DFS link (if it is Samba server you can see instructions at
https://wiki.samba.org/index.php/Distributed_File_System_(DFS) and if
the server is Windows there are lots of walkthroughs explaining DFS
setup (https://mizitechinfo.wordpress.com/2013/08/21/step-by-step-deploy-dfs-in-windows-server-2012-r2/)

cifs.ko in Linux (whether mounted with cifs or smb3) will expect a
pathname in a normal symlink.    Also note that since symbolic links
are typically not supported by Windows servers (with some exceptions
for admin created symlinks), the mount option "mfsymlinks" on the
client may be needed - to ensure that symlinks are being emulated.

On Mon, Aug 29, 2016 at 9:42 AM, Cong Monkey <congzhangzh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> HI All,
>     I try to mount.cifs a windows server share on debian, it works well.
>     But, I have trobule with symbol directory which create with mklink /D
> abc  \\thesameserver\ddd\eee, and it works if the link create with mklink
> /D abc  ddd\eee.
>     My question is, is mount.cifs possible to work full path symbol link?
>     Thanks,
> Cong
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
