From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Handling the 7 reserved characters when mounted to Mac
Date: Wed, 17 Sep 2014 20:08:56 -0500
Message-ID: <CAH2r5msR-Ajhc_Y24pbfKHzXak9Ue0_jDOwUF=+bjAsQMFNb+Q@mail.gmail.com>
References: <CAH2r5mtS8-+Y+mFjezqNKQPF+oXWZg3OOk9=E=mCHJqSCSEHdQ@mail.gmail.com>
 <CAH2r5mtjm3dbxtfn=ke_n9uj4NCS1tK0i3Ch2iUvkVvEovjb5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtjm3dbxtfn=ke_n9uj4NCS1tK0i3Ch2iUvkVvEovjb5w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Also should note that the attached diff only allows reading the
characters in filenames, creating a file will use the normal 'SFU'
style remap range not the mac style range without an additional patch
for conversion the other direction (which I am holding off on until I
can decide for sure how to tell that the server at the other end is a
Mac)

On Wed, Sep 17, 2014 at 8:06 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> One minor clarification
>
> On Mac files can be created with the 7 reserved characters (but they
> get remapped automatically on the wire).  On Windows you would have to
> have SFU (services for unix), or SUA or equivalent in order to create
> such files (and those characters get remapped when stored), and of
> course CIFS/SMB2/SMB3 treats them as reserved as well (thus the need
> to remap them).
>
> On Wed, Sep 17, 2014 at 8:03 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> There are seven reserved characters that need to be remapped when
>> mounting to Windows, Mac (or any server without Unix Extensions) which
>> are valid in POSIX but not in the other OS.
>>
>> : \ < > ? * |
>>
>> We use the normal UCS-2 remap range for this in order to convert this
>> to/from UTF8 as did Windows Services for Unix (basically add 0xF000 to
>> any of the 7 reserved characters).
>>
>> Mac used a very slightly different "Services for Mac" remap range
>> 0xF021 through 0xF027.  The attached patch allows cifs.ko (the kernel
>> client) to read directories on macs containing files with these
>> characters and display their names properly.  In theory this even
>> might be useful on mounts to Samba when the vfs_catia module is loaded
>> and we are mounted with smb3.
>>
>> Currently the 7 reserved characters look very strange in directory
>> listings from cifs.ko to Mac server.  This patch allows these file
>> name characters to be read (requires specifying mapchars on mount).
>>
>> Two additional changes are needed:
>> 1) Make it more automatic: a way of detecting that we are mounted to a
>> Mac so we know to try to always remap these characters (at least for
>> smb2.1 mounts to them and eventually smb3 when they support that)
>>
>> 2) A deterministic way of deciding when to use the normal mapchars
>> approach vs. the mac mappings when creating a file with any of the
>> seven characters in its name.  It may be ok in some cases to be able
>> to translate file names in both formats properly when listing
>> directories - but when creating files we have to use the same
>> mechanism and decide when to use which, especially on SMB3 mounts
>> (which do not have an option for posix pathnames).  Will need to
>> decouple turning mac character mapping on/off from mapchars mount
>> option.
>>
>> --
>> Thanks,
>>
>> Steve
>
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
