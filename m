From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Allow passwords which begin with a delimitor
Date: Wed, 10 Apr 2013 15:57:13 -0500
Message-ID: <CAH2r5mvLMcqtB4RfL5QPHaDFcie3o_yurm0q-M4KdFAVJ=itzw@mail.gmail.com>
References: <1365527861-6624-1-git-send-email-sprabhu@redhat.com>
	<20130410070525.640b460f@corrin.poochiereds.net>
	<1365594475.2110.0.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Peter Maloney <peter.maloney-bU717sqhW2kTELwDM1PSjyEWGD4kr0XT@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1365594475.2110.0.camel@localhost>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Merged into cifs-2.6.git for-next   (added cc: stable too).  Will try
to get this in soon.

On Wed, Apr 10, 2013 at 6:47 AM, Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Wed, 2013-04-10 at 07:05 -0400, Jeff Layton wrote:
>> On Tue,  9 Apr 2013 18:17:41 +0100
>> Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>
>> > Fixes a regression in cifs_parse_mount_options where a password
>> > which begins with a delimitor is parsed incorrectly as being a blank
>> > password.
>> >
>> > Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> > ---
>> >  fs/cifs/connect.c | 16 +++++++++++++---
>> >  1 file changed, 13 insertions(+), 3 deletions(-)
>> >
>> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> > index 12b3da3..f7199b9 100644
>> > --- a/fs/cifs/connect.c
>> > +++ b/fs/cifs/connect.c
>> > @@ -1546,14 +1546,24 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
>> >                     }
>> >                     break;
>> >             case Opt_blank_pass:
>> > -                   vol->password = NULL;
>> > -                   break;
>> > -           case Opt_pass:
>> >                     /* passwords have to be handled differently
>> >                      * to allow the character used for deliminator
>> >                      * to be passed within them
>> >                      */
>> >
>> > +                   /*
>> > +                    * Check if this is a case where the  password
>> > +                    * starts with a delimiter
>> > +                    */
>> > +                   tmp_end = strchr(data, '=');
>> > +                   tmp_end++;
>> > +                   if (!(tmp_end < end && tmp_end[1] == delim)) {
>> > +                           /* No it is not. Set the password to NULL */
>> > +                           vol->password = NULL;
>> > +                           break;
>> > +                   }
>> > +                   /* Yes it is. Drop down to Opt_pass below.*/
>> > +           case Opt_pass:
>> >                     /* Obtain the value string */
>> >                     value = strchr(data, '=');
>> >                     value++;
>>
>> Looks reasonable to me. Should this also go to stable?
>>
>
> Yes. This will also need to be fixed in stable.
>
>> Acked-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>



-- 
Thanks,

Steve
