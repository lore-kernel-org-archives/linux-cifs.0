From: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix IP address bounds checking on mount utility.
Date: Thu, 22 Nov 2012 12:31:50 -0500
Message-ID: <CAFB9KM1uktUTtO5PuYkJjsavGdqpZrZ7YUd80_0Js=uOPUX1AA@mail.gmail.com>
References: <1353528652-8912-1-git-send-email-scott.lovenberg@gmail.com>
	<CAFB9KM1NDQB3HTVCKBjRu=N9nvfoY0YK-5TZN91PwqduD=KJZA@mail.gmail.com>
	<CAOhYWN+Xq5hhPJ1fEQg2AN=UM8k7N22Tfwo424a145KpK0AKDw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOhYWN+Xq5hhPJ1fEQg2AN=UM8k7N22Tfwo424a145KpK0AKDw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Nov 21, 2012 at 4:52 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>
> On Nov 21, 2012 3:16 PM, "Scott Lovenberg" <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> wrote:
>>
>> On Wed, Nov 21, 2012 at 3:10 PM, <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >
>> > From: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> >
>> > Signed-off-by: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> > ---
>> >  mount.cifs.c |    4 ++--
>> >  1 files changed, 2 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/mount.cifs.c b/mount.cifs.c
>> > index a9632b4..f63c309 100644
>> > --- a/mount.cifs.c
>> > +++ b/mount.cifs.c
>> > @@ -941,8 +941,8 @@ parse_options(const char *data, struct
>> > parsed_mount_info *parsed_info)
>> >                         if (!value || !*value) {
>> >                                 fprintf(stderr,
>> >                                         "target ip address argument
>> > missing\n");
>> > -                       } else if (strnlen(value, MAX_ADDRESS_LEN) <=
>> > -                               MAX_ADDRESS_LEN) {
>> > +                       } else if (strnlen(value, MAX_ADDR_LIST_LEN + 1)
>> > <=
>> > +                               MAX_ADDR_LIST_LEN) {
>> >                                 strcpy(parsed_info->addrlist, value);
>> >                                 if (parsed_info->verboseflag)
>> >                                         fprintf(stderr,
>> > --
>> > 1.7.5.4
>> >
>>
>> I still suck at git send-email.  The body of that should have read:
>> "In the mount utility use MAX_ADDR_LIST_LEN for bounds checking on ip
>> addresses instead of MAX_ADDRESS_LEN.  Parsed_mount_info->addrlist is
>> MAX_ADDR_LIST_LEN chars long."
>>
>> --
>> Peace and Blessings,
>> -Scott.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> Erm...except that ip= can only specify a single address. MAX_ADDRESS_LEN is
> the length of a single address whereas MAX_ADDR_LIST_LEN is 16 times that
> value. I'm not clear on what the perceived bug is here...
>

Hrm... I'm a bit confused as to why the parsed_mount_info has
addrlist[MAX_ADDR_LIST_LEN] if it's only going to hold a single IP.
Happy Thanksgiving, Jeff.

-- 
Peace and Blessings,
-Scott.
