From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH][CIFS] Workaround MacOS server problem with SMB2.1 write response
Date: Thu, 14 Aug 2014 15:37:05 -0500
Message-ID: <CAH2r5mv_jjy+nib1gm9b==9Dk_dAv_OYOGxk4Lt07hi1Luq4=w@mail.gmail.com>
References: <CAH2r5msWAcy41S85b5eN5QBZSqwXDnQU07yHS0gnKE+zaaXw4A@mail.gmail.com>
 <20140814153015.030657f7@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Jeff Layton <jeff.layton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140814153015.030657f7-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Aug 14, 2014 at 2:30 PM, Jeff Layton
<jeff.layton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org> wrote:
> On Tue, 12 Aug 2014 09:19:42 -0500
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> Writes fail to Mac servers with SMB2.1 mounts (works with cifs though) due
>> to them sending an incorrect RFC1001 length. Workaround this problem.
>> MacOS server sends a write response with 3 bytes of pad beyond the end
>> of the SMB itself.  The RFC1001 length is 3 bytes more than
>> the sum of the SMB2.1 header length + the write reponse.
>>
>> Since we have seen a few other examples where servers have
>> padded responses strangely (oplock break and create),
>> allow servers to send a padded SMB2/SMB3 response to allow
>> for rounding (up to 15 bytes).
>>
>> Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>>  fs/cifs/smb2misc.c | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
>> index f2e6ac2..da05beb 100644
>> --- a/fs/cifs/smb2misc.c
>> +++ b/fs/cifs/smb2misc.c
>> @@ -181,6 +181,12 @@ smb2_check_message(char *buf, unsigned int length)
>>          /* server can return one byte more */
>>          if (clc_len == 4 + len + 1)
>>              return 0;
>
> Not directly related to this patch, but...
>
> What's the story behind the check above? Allowing the server to overrun
> the rfc1001 length by one byte seems dangerous...

The problem IIRC was that at least one of the SMB2 requests/responses
was defined
with an implied data area which is at least 1 byte even if not present
(might be SMB2 read since struct size is odd, 17).  We had only run into
one other case (oplock break response) where length check was off,
so I prefer to stay stricter and safer if we don't know of any
interoperability issues.


-- 
Thanks,

Steve
