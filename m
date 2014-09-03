From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Latest xfstest results
Date: Wed, 3 Sep 2014 10:22:02 +0400
Message-ID: <CAKywueRGTduS=nOHOn52R5K40HfmSsw8ew0u4D=3Y1AhfGHx9w@mail.gmail.com>
References: <CAH2r5msh2j2qPsfNPsO2gMb8a_=snKUD=VpuAKhdMO_qopOsLw@mail.gmail.com>
	<20140829172014.GA16006@infradead.org>
	<CAH2r5msZsL_LcjAUshLTArTFaFs5M136izeBGnXXf1uitYJsDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msZsL_LcjAUshLTArTFaFs5M136izeBGnXXf1uitYJsDA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2014-09-02 7:05 GMT+04:00 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> These are good suggestions - working through 215 and 313 is turning
> out to be a little more complicated than I expected though.
>
> On Fri, Aug 29, 2014 at 12:20 PM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>> Seems like most of your issues are time stamp updates, so you
>> should look into that area a lot more.  Some that I know off head what
>> the issues are:
>>
>> On Fri, Aug 29, 2014 at 10:33:14AM -0500, Steve French wrote:
>>> QA output created by 215
>>>
>>> creating test file
>>> 4096+0 records in
>>> 4096+0 records out
>>>
>>> writing via mmap
>>> FAIL: mtime not update after mapped write
>>> FAIL: ctime not update after mapped write
>>
>> missing file_update_time call in cifs_page_mkwrite.
>
> Just adding that didn't fix it - but will look further into it. Maybe
> server is delaying updating mtime and getting reset back to original
> time stamp during revalidate.  Need to debug further.
>

As for 215 tests: we are setting the superblock flags to MS_NODIRATIME
| MS_NOATIME during mounting (684 line, cifsfs.c). Then in cifs_iget()
we are setting inode->i_flags to S_NOATIME | S_NOCMTIME (929 line,
inode.c).

In file_update_time() we are checking for IS_NOCMTIME(inode) and exit
if it's true. So, this call does nothing for cifs and not change to
behavior.

-- 
Best regards,
Pavel Shilovsky.
