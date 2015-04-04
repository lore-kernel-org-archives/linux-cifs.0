From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Don't replace dentries for dfs mounts
Date: Fri, 3 Apr 2015 20:57:44 -0500
Message-ID: <CAH2r5mt1JHCsnmTQmOgT5gSozig=UAreT=zqjuqDMsLtciqVJw@mail.gmail.com>
References: <1427982695-29891-1-git-send-email-sprabhu@redhat.com> <20150403081406.1f8323d1@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jeff.layton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150403081406.1f8323d1-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Looks reasonable but fails on SMB3 - we need to fix lines 133 and 134
of smb2pdu.c as well

On Fri, Apr 3, 2015 at 7:14 AM, Jeff Layton <jeff.layton-7I+n7zu2hfthDmVcRT8U2w@public.gmane.org=
m> wrote:
> On Thu,  2 Apr 2015 14:51:35 +0100
> Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
>> Doing a readdir on a dfs root can result in the dentries for directo=
ries
>> with a dfs share mounted  being replaced by new dentries for objects
>> returned by the readdir call. These new dentries on shares mounted w=
ith
>> unix extenstions show up as symlinks pointing to the dfs share.
>>
>>  # mount -t cifs -o sec=3Dnone  //vm140-31/dfsroot cifs
>>  # stat cifs/testlink/testfile; ls -l cifs
>>   File: =E2=80=98cifs/testlink/testfile=E2=80=99
>>   Size: 0             Blocks: 0          IO Block: 16384  regular
>> empty file
>> Device: 27h/39d       Inode: 130120      Links: 1
>> Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    r=
oot)
>> Access: 2015-03-31 13:55:50.106018200 +0100
>> Modify: 2015-03-31 13:55:50.106018200 +0100
>> Change: 2015-03-31 13:55:50.106018200 +0100
>>  Birth: -
>> total 0
>> drwxr-xr-x 2 root root  0 Mar 31 13:54 testdir
>> lrwxrwxrwx 1 root root 19 Mar 24 14:25 testlink -> \vm140-31\test
>>
>> In the example above, the stat command mounts the dfs share at
>> cifs/testlink. The subsequent ls on the dfsroot directory replaces t=
he
>> dentry for testlink with a symlink.
>>
>> In the earlier code, the d_invalidate command returned an -EBUSY err=
or
>> when attempting to invalidate directories. This stopped the code fro=
m
>> replacing the directories with symlinks returned by the readdir call=
=2E
>> Changes were recently made to the d_invalidate() command so
>> that it no longer returns an error code. This results in the directo=
ry
>> with the mounted dfs share being replaced by a symlink which denotes=
 a
>> dfs share.
>>
>> Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>>  fs/cifs/readdir.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
>> index c295338..b4bda47 100644
>> --- a/fs/cifs/readdir.c
>> +++ b/fs/cifs/readdir.c
>> @@ -90,6 +90,8 @@ cifs_prime_dcache(struct dentry *parent, struct qs=
tr *name,
>>       if (dentry) {
>>               inode =3D dentry->d_inode;
>>               if (inode) {
>> +                     if (d_mountpoint(dentry))
>> +                             goto out;
>>                       /*
>>                        * If we're generating inode numbers, then we =
don't
>>                        * want to clobber the existing one with the o=
ne that
>
>
> Looks right.
>
> Reviewed-by: Jeff Layton <jeff.layton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--=20
Thanks,

Steve
