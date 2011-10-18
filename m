From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH] cifs-utils: mention the kernel version that introduced
 getcifsacl
Date: Tue, 18 Oct 2011 15:36:42 +0530
Message-ID: <4E9D4FB2.6070109@suse.de>
References: <4E9D1E5D.4020603@suse.de> <CADT32eLiG_oqKEu6dtEXyH6kepMwGt+G_+5OJTxefO8y85oCHA@mail.gmail.com>
Reply-To: sjayaraman-l3A5Bk7waGM@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eLiG_oqKEu6dtEXyH6kepMwGt+G_+5OJTxefO8y85oCHA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 10/18/2011 03:05 PM, Shirish Pargaonkar wrote:
> On Tue, Oct 18, 2011 at 1:36 AM, Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:
>>
>> Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
>> ---
>>  getcifsacl.8.in |    3 +++
>>  1 files changed, 3 insertions(+), 0 deletions(-)
>>
>> diff --git a/getcifsacl.8.in b/getcifsacl.8.in
>> index 02e1355..f79f7ff 100644
>> --- a/getcifsacl.8.in
>> +++ b/getcifsacl.8.in
>> @@ -40,6 +40,9 @@ Print version number and exit\&.
>>  .RS 4
>>  Display a security descriptor in raw mode. Values such as type and flags are displayed in hexadecimal format, a SID is not mapped to a name.
>>  .RE
>> +.SH "NOTES"
>> +.PP
>> +Kernel support for getcifsacl/setcifsacl utilities was initially introduced in the 2.6.37 kernel.
> 
> Looks fine.  Just a nitpicking, since this is a getcifsacl manpage,
> does setcifsacl also need to be mentioned here?

The thought behind this was that - though the man pages are different,
users will see them as single facility and would want to use them
together mostly (assumption here is that a user who is reading and using
getcifsacl or setcifsacl would also read and use the other sooner).


Suresh

> Reviewed-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
>>  .SH "SEE ALSO"
>>  .PP
>>  \fBmount.cifs\fR(8),
>>
