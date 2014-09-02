From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Latest xfstest results
Date: Mon, 1 Sep 2014 22:05:22 -0500
Message-ID: <CAH2r5msZsL_LcjAUshLTArTFaFs5M136izeBGnXXf1uitYJsDA@mail.gmail.com>
References: <CAH2r5msh2j2qPsfNPsO2gMb8a_=snKUD=VpuAKhdMO_qopOsLw@mail.gmail.com>
 <20140829172014.GA16006@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140829172014.GA16006-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

These are good suggestions - working through 215 and 313 is turning
out to be a little more complicated than I expected though.

On Fri, Aug 29, 2014 at 12:20 PM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> Seems like most of your issues are time stamp updates, so you
> should look into that area a lot more.  Some that I know off head what
> the issues are:
>
> On Fri, Aug 29, 2014 at 10:33:14AM -0500, Steve French wrote:
>> QA output created by 215
>>
>> creating test file
>> 4096+0 records in
>> 4096+0 records out
>>
>> writing via mmap
>> FAIL: mtime not update after mapped write
>> FAIL: ctime not update after mapped write
>
> missing file_update_time call in cifs_page_mkwrite.

Just adding that didn't fix it - but will look further into it. Maybe
server is delaying updating mtime and getting reset back to original
time stamp during revalidate.  Need to debug further.

>> QA output created by 313
>> Silence is golden
>> ctime not updated after truncate
>> mtime not updated after truncate
>
> missing update of c/mtime for truncate.  The VFS is nasty in it's
> setattr calling conventions for this.

That is very true. This is turning out to be harder to decipher than I expected.

>Check my
> "[PATCH] nfs: update time staps on truncate"
>
> post on the nfs list for details.

My first pass at using the approach suggested in the NFS patch didn't
work, and an alternative approach of skipping mtime update (set info
of the timestamps to server) completely in the ATTR_SIZE case and
simply forcing revalidate of all inode metadata from the server
(setting cifsInode->time to zero forces revalidate) actually broke
ftruncate not just truncate (reminded me of something IIRC JRA had
said about delayed updates of mtime in NTFS - need to dig up that old
note).


-- 
Thanks,

Steve
