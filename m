From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [CIFS] various endian fixes to cifs
Date: Sun, 13 Mar 2011 16:11:56 -0400
Message-ID: <20110313201156.GB14090@infradead.org>
References: <AANLkTinKT2123BKR3RypvJ3Up3yvd3gs1J366WJ6C0kJ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	"Stefan (metze) Metzmacher" <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AANLkTinKT2123BKR3RypvJ3Up3yvd3gs1J366WJ6C0kJ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, Mar 12, 2011 at 11:05:51PM -0600, Steve French wrote:
> In checking new smb2 code for missing endian conversions, I noticed
> some endian errors had crept in over the last few releases into the
> cifs code (symlink, ntlmssp, posix lock, and less problematic warning
> in fscache).   Patch follows:

Is this part of a sparse run or did you check them manually?
