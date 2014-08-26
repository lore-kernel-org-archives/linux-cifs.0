From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cthon failure
Date: Mon, 25 Aug 2014 21:04:21 -0500
Message-ID: <CAH2r5mtdkx=iPmQBUq2RLf15zRfLnfFxZU6Y7bRLRtU09Cv1mw@mail.gmail.com>
References: <CAH2r5mtN1cHocFcVPsDC9kVq5c9DyxazmTBFQp_wUVCPNsvV7Q@mail.gmail.com>
 <20140821211338.GC17035@samba2> <CAH2r5ms5=vV2XD2oP2NoaLavsZCo=x4w=w7vvshzNQRNJ1RkFw@mail.gmail.com>
 <20140826001033.GA7407@samba2>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140826001033.GA7407@samba2>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I can create a bug but the problem is pretty straightforward

[2014/08/25 14:12:33.849169,  1]
../source3/smbd/file_access.c:191(can_set_delete_on_close)
  can_set_delete_on_close: file newfile1 delete on close flag set but
file attribute is readonly.
[2014/08/25 14:12:33.849188,  5]
../lib/dbwrap/dbwrap.c:146(dbwrap_lock_order_state_destructor)
  release lock order 1 for /usr/local/samba/var/lock/locking.tdb
[2014/08/25 14:12:33.849201,  5]
../lib/dbwrap/dbwrap.c:178(dbwrap_check_lock_order)
  check lock order 1 for /usr/local/samba/var/lock/locking.tdb
[2014/08/25 14:12:33.849243,  5]
../lib/dbwrap/dbwrap.c:146(dbwrap_lock_order_state_destructor)
  release lock order 1 for /usr/local/samba/var/lock/locking.tdb
[2014/08/25 14:12:33.849262,  2] ../source3/smbd/close.c:780(close_normal_file)
  sfrench closed file newfile1 (numopen=0) NT_STATUS_OK
[2014/08/25 14:12:33.849295,  5]
../lib/dbwrap/dbwrap.c:178(dbwrap_check_lock_order)
  check lock order 1 for /usr/local/samba/var/lock/smbXsrv_open_global.tdb
[2014/08/25 14:12:33.849313,  5]
../lib/dbwrap/dbwrap.c:146(dbwrap_lock_order_state_destructor)
  release lock order 1 for /usr/local/samba/var/lock/smbXsrv_open_global.tdb
[2014/08/25 14:12:33.849329,  5] ../source3/smbd/files.c:528(file_free)
  freed files structure 23406 (0 used)
[2014/08/25 14:12:33.849344,  3] ../source3/smbd/error.c:82(error_packet_set)
  NT error packet at ../source3/smbd/trans2.c(8321) cmd=50 (SMBtrans2)
NT_STATUS_CANNOT_DELETE

NTSTATUS can_set_delete_on_close(files_struct *fsp, uint32 dosmode)
{
    /*
     * Only allow delete on close for writable files.
     */

    if ((dosmode & FILE_ATTRIBUTE_READONLY) &&
        !lp_delete_readonly(SNUM(fsp->conn))) {
        DEBUG(1,("can_set_delete_on_close: file %s delete on close "
              "flag set but file attribute is readonly.\n",
              fsp_str_dbg(fsp)));
        return NT_STATUS_CANNOT_DELETE;
    }


Another way to get this to work would be to add

       delete readonly (S)

           This parameter allows readonly files to be deleted. This is not
           normal DOS semantics, but is allowed by UNIX.

           This option may be useful for running applications such as rcs,
           where UNIX file ownership prevents changing file permissions, and
           DOS semantics prevent deletion of a read only file.

           Default: delete readonly = no


On Mon, Aug 25, 2014 at 7:10 PM, Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Mon, Aug 25, 2014 at 07:05:53PM -0500, Steve French wrote:
>> I just tried it on recent Samba (from about a week ago) with the same results
>>
>> Version 4.2.0pre1-GIT-47e7440
>> and also
>> Version 4.1.6-Ubuntu
>>
>> If "store dos attributes = yes" (on by default in Ubuntu) is in smb.conf
>>
>> then the following fails
>> mount -t cifs //someserver/someshare /mnt
>> touch /mnt/newfile1
>> chmod 0000 /mnt/newfile1
>> stat /mnt/newfile1   (mode displays as expected)
>> rm /mnt/newfile1  (fails with access denied)
>>
>> if the identical scenario is tried with "store dos attributes = no" in
>> smb.conf then it works
>> mount -t cifs //someserver/someshare /mnt
>> touch /mnt/newfile2
>> chmod 0000 /mnt/newfile2
>> stat /mnt/newfile2  (mode displays as expected)
>> rm /mnt/newfile2   (delete works), and also removing the newfile1
>> created above also works)
>> rm /mnt/newfile1 (also works)
>>
>> Details:
>> posix unlink (set path info) fails with access denied/status cannot
>> delete, as does subsequent smb delete.   Attempts to clear the
>> readonly bit also fails with access denied
>>
>> The chmod 0000 causes Samba server to set the read-only dos attribute
>> in the failing case
>
> As I said - can't reproduce here so obviously reporting
> the same thing I already used to reproduce isn't going to help :-).
>
> Can you get me YOUR ENTIRE smb.conf, debug level 10 log,
> wireshark trace of the activity please.
>
> Log a bug and attach them - easiest way to track.



-- 
Thanks,

Steve
