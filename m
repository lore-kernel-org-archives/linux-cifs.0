From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: nfs/cifs mountinfo differences (was: Re: [PATCH] libmount: Skip
 root comparison for cifs in mnt_table_is_fs_mounted())
Date: Wed, 3 Aug 2016 15:32:20 -0500
Message-ID: <CAH2r5mtV0YkWUypcOAeA9rVGMjKkBqBGdY2ht1hyXPG3JRWRiA@mail.gmail.com>
References: <91d465d3-4f5b-6270-a6c5-38bd94695731@suse.cz> <5eb96b3e-d463-bf11-49de-f614247d6b29@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5eb96b3e-d463-bf11-49de-f614247d6b29-AlSwsSmVLrQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

patch looks reasonable to me.

On Wed, Aug 3, 2016 at 12:23 PM, Stanislav Brabec <sbrabec-AlSwsSmVLrQ@public.gmane.org> wrote:
> Stanislav Brabec wrote:
>>
>> In mountinfo of cifs filesystem, root is filled with a relative path to
>> the root
>> of the exported volume. There is no reasonable way to compare it without
>> making
>> a network look-up.
>
>
> This is an original problem of "mount -a", see How to reproduce below.
>
>> This causes false negative result in some cases.
>>
>> Skipping root comparison in mnt_table_is_fs_mounted() makes things better,
>> however it still does not cover all possible setups.
>
>
> I just compared behavior of cifs and nfs4 in this situation.
>
> cifs and nfs4 provide different mountinfo. So maybe it is more an
> inconsistency of procinfo root entry than problem of mount.
>
> Sending mail also to linux-cifs to get an opinion.
>
> When mounting subdirectory of exported nfs4 volume, 4th record (root)
> remains "/".
>
> When mounting subdirectory of exported cifs volume, 4th record (root) is the
> "/subdir", and 9th record (source) contains fill path
> "//server/volume/subdir".
>
> And for comparison, when bind mounting cifs subdirectory out of volume
> mount, 4th record is "/subdir" as well, but the string in 9th record
> (source) does not contain trailing "/subdir", just "//server/volume".
>
> And for completness, when bind mounting subdirectory of a btrfs subvolume,
> 4th record (root) contains full path to the subdirectory relative to the
> volume root (i. e. including subvolume path). Content of 9th record (source)
> is not relevant for comparison, as it contains /dev/sd* node.
>
>> How to reproduce:
>> 1) Create and export a cifs volume (with guest allowed).
>> 2) Make a subdirectory in this volume.
>> 3) Mount this subdirectory using fstab:
>>    //server/volume/subdir /mnt cifs guest 0 0
>> 4) Call mount -a twice.
>>    Depending on a system running, you either get:
>>      mount error(16): Device or resource busy
>>      Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
>>    or you get a volume mounted twice.
>>
>> Signed-off-by: Stanislav Brabec <sbrabec-AlSwsSmVLrQ@public.gmane.org>
>> ---
>
>
> Here is the proposed patch for util-linux:
>
>>  libmount/src/tab.c | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/libmount/src/tab.c b/libmount/src/tab.c
>> index 155c65e..aa9185a 100644
>> --- a/libmount/src/tab.c
>> +++ b/libmount/src/tab.c
>> @@ -1562,7 +1562,10 @@ int mnt_table_is_fs_mounted(struct libmnt_table
>> *tb, struct libmnt_fs *fstab_fs)
>>  #endif
>>                 }
>>
>> -               if (root) {
>> +               /* For cifs, root contains a relative path to the exported
>> volume,
>> +                * i. e. something we cannot compare.
>> +                */
>> +               if (root && strcmp(mnt_fs_get_fstype(fs), "cifs")) {
>>                         const char *r = mnt_fs_get_root(fs);
>>                         if (!r || strcmp(r, root) != 0)
>>                                 continue;
>>
>
> --
> Best Regards / S pozdravem,
>
> Stanislav Brabec
> software developer
> ---------------------------------------------------------------------
> SUSE LINUX, s. r. o.                         e-mail: sbrabec-IBi9RG/b67k@public.gmane.org
> Křižíkova 148/34 (Corso IIa)                  tel: +49 911 7405384547
> 186 00 Praha 8-Karlín                          fax:  +420 284 084 001
> Czech Republic                                    http://www.suse.cz/
> PGP: 830B 40D5 9E05 35D8 5E27 6FA3 717C 209F A04F CD76
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
