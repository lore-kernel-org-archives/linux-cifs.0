From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: guard against entries being deleted from open file list
Date: Mon, 18 Apr 2011 22:02:21 -0500
Message-ID: <BANLkTimuLqbz6fj9SuV+_3KmuJ9Keh_9hg@mail.gmail.com>
References: <1303134275-12587-1-git-send-email-shirishpargaonkar@gmail.com>
	<20110418105025.2b62fa69@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110418105025.2b62fa69-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Apr 18, 2011 at 9:50 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Mon, 18 Apr 2011 08:44:35 -0500
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>>
>> It is possible that a close can occur while a file is
>> being reopened which can result in list entry deleted
>> from the list and an oops.
>> Use list_for_each_entry_safe instead.
>>
>>
>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> =A0fs/cifs/file.c | =A0 =A05 +++--
>> =A01 files changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> index faf5952..aa29167 100644
>> --- a/fs/cifs/file.c
>> +++ b/fs/cifs/file.c
>> @@ -1056,7 +1056,7 @@ struct cifsFileInfo *find_readable_file(struct=
 cifsInodeInfo *cifs_inode,
>> =A0struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *cif=
s_inode,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 bool fsuid_only)
>> =A0{
>> - =A0 =A0 struct cifsFileInfo *open_file;
>> + =A0 =A0 struct cifsFileInfo *open_file, *tmpf;
>> =A0 =A0 =A0 struct cifs_sb_info *cifs_sb;
>> =A0 =A0 =A0 bool any_available =3D false;
>> =A0 =A0 =A0 int rc;
>> @@ -1079,7 +1079,8 @@ struct cifsFileInfo *find_writable_file(struct=
 cifsInodeInfo *cifs_inode,
>>
>> =A0 =A0 =A0 spin_lock(&cifs_file_list_lock);
>> =A0refind_writable:
>> - =A0 =A0 list_for_each_entry(open_file, &cifs_inode->openFileList, =
flist) {
>> + =A0 =A0 list_for_each_entry_safe(open_file, tmpf, &cifs_inode->ope=
nFileList,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fl=
ist) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!any_available && open_file->pid !=3D=
 current->tgid)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (fsuid_only && open_file->uid !=3D cu=
rrent_fsuid())
>
> I don't think this is a real fix for this problem, and may cause othe=
r
> issues. list_for_each_entry_safe is only protects you when you are
> iterating over a list (usually while holding a lock) and removing tho=
se
> entries. The *_safe part makes it ok to remove the entry that you're
> currently dealing with from the list.
>
> Now, that can happen if you find an entry, do a cifsFileInfo_get, dro=
p
> the spinlock and then calling cifsFileInfo_put and putting the last
> reference afterward. Here's the problem though -- once you drop the
> spinlock, there's nothing that says that the next entry in the list i=
s
> necessarily still valid once you move to that entry.
>
> What if the entry *after* the one that you're currently dealing with =
is
> removed from the list while you're iterating over it? This patch will
> cause an oops in that situation now when it didn't before. So, I thin=
k
> this patch will probably just trade one set of problems for another.
>
> I think the real fix is overhauling how all of the reopen_file stuff
> works, but fixing it looks anything but straightforward.
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>

Jeff, I do not mind taking a stab at it.  Do you have suggestsion/ideas
about how to approach it?

Regards,

Shirish
