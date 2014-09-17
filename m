From: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: match_token weird behavior
Date: Wed, 17 Sep 2014 13:33:11 -0700
Message-ID: <5419F007.9070509@infradead.org>
References: <CAH2r5mvTP1oGNoetuSkPdirBb1UDH6fiNCVjs_gJNKeJ1Dz5sA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvTP1oGNoetuSkPdirBb1UDH6fiNCVjs_gJNKeJ1Dz5sA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 09/17/14 11:20, Steve French wrote:
> Noticing something very strange with match_token.   I had five strings
> I need to compare a version string (protocol dialect eg. "2.1" or
> "3.0") against, to find which it matches (if any), but adding one to
> the list (now checking for one of six strings instead of five) causes
> the error case to always default to element 3 (in my example looks as
> if it matched to the 2.1 string) instead of the error case.
> 
> enum smb_version {
>     Smb_1 = 1,
>     Smb_20,
>     Smb_21,
>     Smb_30,
>     Smb_302,
> };
> 
> static const match_table_t cifs_smb_version_tokens = {
>     { Smb_1, SMB1_VERSION_STRING },
>     { Smb_20, SMB20_VERSION_STRING},
>     { Smb_21, SMB21_VERSION_STRING },
>     { Smb_30, SMB30_VERSION_STRING },
>     { Smb_302, SMB302_VERSION_STRING },
> };
> 

You don't tell us what the actual string values are, but I'm guessing that
SMB302_VERSION_STRING is a subset (same in first N characters) of SMB30_VERSION_STRING. ??

In that case I think that match_token() will return a ptr to SMB_30 instead of to
SMB_302 when the input is "3.02" (matches "3.0" due to the kernel's implementation
of strcmp() stopping at the end of string1 (where string1 is "3.0" in this case).

If that is all correct, then could your return value be off by 1?

> 
> When I add one entry to the lists above (going from 5 to 6 elements),
> and then add one additional case for it to the switch statement, an
> attempt to provide an unrecognized string (e.g. if I specify an illegal
> dialect string like "9" instead of "3.0" or "2.1" etc) will now match the
> third element (Smb_21) instead of "default" in the code snippet below.
> Is match_token broken? Can match token only handle tables with 5
> elements or fewer? Is there a replacement for it for this kind of thing
> (matching a string versus which from among a list of valid strings)
> other than match_token?  Is match_token just broken?
> 
>     substring_t args[MAX_OPT_ARGS];
> 
>     switch (match_token(value, cifs_smb_version_tokens, args)) {
>     case Smb_1:
>         vol->ops = &smb1_operations;
>         vol->vals = &smb1_values;
>         break;
>     case Smb_20:
>         vol->ops = &smb20_operations;
>         vol->vals = &smb20_values;
>         break;
>     case Smb_21:
>         vol->ops = &smb21_operations;
>         vol->vals = &smb21_values;
>         break;
>     case Smb_30:
>         vol->ops = &smb30_operations;
>         vol->vals = &smb30_values;
>         break;
>     case Smb_302:
>         vol->ops = &smb30_operations; /* currently identical with 3.0 */
>         vol->vals = &smb302_values;
>         break;
>     default:
>         cifs_dbg(VFS, "Unknown vers= option specified: %s\n", value);
>         return 1;
> 


-- 
~Randy
