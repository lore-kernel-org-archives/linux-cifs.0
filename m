From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [CIFS] various endian fixes to cifs
Date: Sun, 13 Mar 2011 16:37:02 -0500
Message-ID: <AANLkTikHHSJ+4KUTOJGhAu2cfjC2Eq4Jqqkdct=tFrTk@mail.gmail.com>
References: <AANLkTinKT2123BKR3RypvJ3Up3yvd3gs1J366WJ6C0kJ@mail.gmail.com>
	<20110313201156.GB14090@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	"Stefan (metze) Metzmacher" <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110313201156.GB14090-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, Mar 13, 2011 at 3:11 PM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> =
wrote:
> On Sat, Mar 12, 2011 at 11:05:51PM -0600, Steve French wrote:
>> In checking new smb2 code for missing endian conversions, I noticed
>> some endian errors had crept in over the last few releases into the
>> cifs code (symlink, ntlmssp, posix lock, and less problematic warnin=
g
>> in fscache). =A0 Patch follows:
>
> Is this part of a sparse run or did you check them manually?

I run sparse before every checkin, but I had not been running
it with checkendian passed in.

I don't know a trivial way to check them automatically (as we see
e.g. with linux-next automatically warning if new build warning
is introduced on some arch).  One thing I
would love to do is figure out how to automate more of the
build verification, unit test process as we do with Samba (for
example).



--=20
Thanks,

Steve
