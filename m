From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Update CreationTime on every query info request
Date: Mon, 11 Aug 2014 10:02:01 -0500
Message-ID: <CADT32eKug8tmF=qLLWrREd=ZvbRMz4-jf2dwzMDCnBPZL=LzRQ@mail.gmail.com>
References: <1407323743-12381-1-git-send-email-pshilovsky@samba.org>
	<20140806072546.14dfbe07@tlielax.poochiereds.net>
	<CAKywueSdDBROX9PokZXkUxocD7aAajQFYMv=ZQfXNDVYLSHRVg@mail.gmail.com>
	<20140806080833.111cd1d4@tlielax.poochiereds.net>
	<CAKywueQJpHjDFUZbDTUhrekOPG5uRx0nv30L+gnBZSW3HbPh_g@mail.gmail.com>
	<20140806093114.2ec5f815@tlielax.poochiereds.net>
	<CAKywueS8CUwp1NBmP0G0sBdhNpJXbO6urxdnz=oeT7frHNAeWA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	"samba-technical-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org" <samba-technical-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueS8CUwp1NBmP0G0sBdhNpJXbO6urxdnz=oeT7frHNAeWA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Aug 6, 2014 at 10:21 AM, Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> 2014-08-06 17:31 GMT+04:00 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
>> On Wed, 6 Aug 2014 16:38:32 +0400
>> Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>>> If server reuses a uniqueid - it is a bug in the server.
>>>
>>
>> Then I think that's probably another samba bug. IIRC, it generates
>> uniqueids using the st_ino and st_dev fields from stat(). There are
>> many Linux filesystems that will aggressively reuse inode numbers and
>> there is no API to get at the inode->i_generation field from userland.
>>
>> --------------[snip]----------------
>> /********************************************************************
>>  Create a 64 bit FileIndex. If the file is on the same device as
>>  the root of the share, just return the 64-bit inode. If it isn't,
>>  mangle as we used to do.
>> ********************************************************************/
>>
>> uint64_t get_FileIndex(connection_struct *conn, const SMB_STRUCT_STAT *psbuf)
>> {
>>         uint64_t file_index;
>>         if (conn->base_share_dev == psbuf->st_ex_dev) {
>>                 return (uint64_t)psbuf->st_ex_ino;
>>         }
>>         file_index = ((psbuf->st_ex_ino) & UINT32_MAX); /* FileIndexLow */
>>         file_index |= ((uint64_t)((psbuf->st_ex_dev) & UINT32_MAX)) << 32; /* FileIndexHigh */
>>         return file_index;
>> }
>> --------------[snip]----------------
>>
>>> The creation time can be changed on the Windows server:
>>> 1) we call stat FILE - construct the inode with the recent info;
>>> 2) on the server another client calls SetFileTime() and updates
>>> CreationTime of the FILE;
>>> 3) we call stat FILE again, get the recent info but don't store the
>>> new CreationTime value and stay with the wrong CreationTime value.
>>>
>>> Also, in this case we can't rely on CreationTime to determine if this
>>> is the same inode or not. I think the best thing is to *trust* the
>>> server that uniqueid is unique (at least for SMB 2.0 and higher
>>> versions).
>>>
>>> Note, that now we use CreationTIme value for the inode search in
>>> iget(). The above example of changing this value on the server shows
>>> that we can end up with several inodes for each "creationtime" version
>>> of the file.
>>>
>>
>> Sure, it's settable and you can abuse it, but who actually does that?
>>
>> It's very rare for someone to mess with the create time like that. I
>> imagine it's generally only done by backup utilities when restoring
>> and maybe rootkits. Those are both sort of outside the scope of
>> normal usage.
>
> Microsoft Office Excel is doing this -- see
> http://www.techrepublic.com/blog/the-enterprise-cloud/why-writing-a-windows-compatible-file-server-is-still-hard/
> story.
> So, it is not a rootkit or backup utility, it's a normal way Windows
> is working with files.
>
>>> The problem is that we don't have unix extensions for SMB 2.0 and
>>> higher protocol versions and we need to use nounix either way.
>>>
>>
>> Then that's a problem that will need to eventually be addressed anyway.
>> I don't see how this is anything but a way to paper over that fact in
>> the meantime.
>
> I really started to think that we can't use CreationTime in
> find_inode() since this is not constant on both Windows and Samba (by
> default). Even more, when negotiating Unix Extensions we always set
> this field to 0. I suggest that we need to do the same thing for
> nounix mounts too. At least we should do it for SMB 2/3 since we don't
> have Unix Extensions for them now.
>
> So, we have two choices from my point of view:
> 1) to update CreationTime value any time we are querying info from the
> server (what exactly this patch does);
> 2) to remove CreationTime checks in find_inode() for nounix at least
> for SMB 2/3 (probably for CIFS too).
>
> Thoughts?
>
> --
> Best regards,
> Pavel Shilovsky.

Would this problem be solved, if more than nounix, we restrict use/criterion
of cratetime in cifs_find_inode() for cases where server does not provide
uniqueids? Not sure how can we check that in cifs_find_inode() though.
