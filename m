From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: noserverino option
Date: Thu, 3 Sep 2015 20:19:13 -0500
Message-ID: <CAH2r5msGGTFORwqs5OsP07FrQu23kV2un3cEEDK0NDXg2y6EHQ@mail.gmail.com>
References: <CAPhxvqOMBJ+2Ph1HT8ggTzacogna15kWQCpsOYVU9JCQD9BhVg@mail.gmail.com>
 <CAH2r5mvj5KWAeKKAud9FcrktGhDvO5CWogc=M4XYgQTxAmeYtA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: John Jackson <john.michael.jackson1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvj5KWAeKKAud9FcrktGhDvO5CWogc=M4XYgQTxAmeYtA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Sorry about the typo ("date" instead of "data")

Running without server inode numbers can cause problems when
hardlinked files are common (since the client thinks they are
different files and they are actually the same
file data).

On Thu, Sep 3, 2015 at 3:11 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Thu, Sep 3, 2015 at 10:06 AM, John Jackson
> <john.michael.jackson1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> Hi Everyone,
>>
>> How does the noserverino operation behave when mounting a CIFS share,
>> what does it do?
>
> noserverino mount option is designed to handle cases where the server
> can not generate a unique inode number (or equivalent) for each file.
> In CIFS and SMB2/SMB3 files are almost always accessed (opened) by
> name, and it is not required that a file system be able to preserve a
> persistent identifier for each file (other than its name), and some
> popular non-Unix/non-Linux file systems, like FAT, don't really have
> inode numbers (or other unique numeric identifiers) although most can
> generate one.  Some buggy servers also will fill 0 in (incorrectly) as
> the inode number making it impossible to distinguish hardlinked files.
>
> In general, for most modern servers they should be able to work fine
> with the default (server inode numbers enabled) which allows the
> client to detect hardlinks.  The cifs client will turn off using the
> server's inode numbers if the server starts returning 0 as inode
> number so we can catch most buggy servers early enough.
>
> Since the caching of files is dependent on (oplocks/leases granted
> when) opening the file by path name, whether or not you use server
> inode numbers should not be a factor.   Running without server inode
> numbers can cause problems when hardlinked files are common (since the
> client thinks they are different files and they are actually the same
> file date).
>
>> I know the man page says, Client generates inode numbers itself rather
>> than using the actual ones from the server,  but how does using the
>> noserverino option affecting caching of a linux client mounting a
>> share with cifs from a NAS.
>>
>>
>> I was recently facing a problem where I had a windows7  machine and a
>> linux(2.6.32) machine concurrently reading/writing files on a synology
>> nas box, And the files were mismatched by 4k, one linux page size on
>> the linux machine. I found that upgrading the kernel to 3.10 or 3.18
>> and using the noserverino option, my problem had gone away. However, I
>> am worried I may have taken a performance hit. .
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
