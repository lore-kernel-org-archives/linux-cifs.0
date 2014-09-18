From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: match_token weird behavior
Date: Thu, 18 Sep 2014 10:10:43 -0700
Message-ID: <CAH2r5muG9QYD+Kj7WHet4BMdt9RqXWfjs4QRHsPWCVQLifXg2g@mail.gmail.com>
References: <CAH2r5mvTP1oGNoetuSkPdirBb1UDH6fiNCVjs_gJNKeJ1Dz5sA@mail.gmail.com>
 <5419F007.9070509@infradead.org> <5419F0D4.9090107@infradead.org>
 <CAH2r5muWCr9VLdQLGr+u-grdk=q+DfgdrRQU2dn2A37yLTAieA@mail.gmail.com> <CAH2r5muvhC6ww_U8o4mN119ptnNsuT+mcSmfaFbP7DqV0ZQpiw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
To: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5muvhC6ww_U8o4mN119ptnNsuT+mcSmfaFbP7DqV0ZQpiw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Sep 17, 2014 at 2:05 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Looking at more examples, some of which are much larger match tables
> maybe it has to do with how the final entry is defined.  In this
> example the NULL match is explicitly stated.
>
> static const match_table_t cifs_secflavor_tokens = {
>     { Opt_sec_krb5, "krb5" },
>     { Opt_sec_krb5i, "krb5i" },
>     { Opt_sec_krb5p, "krb5p" },
>     { Opt_sec_ntlmsspi, "ntlmsspi" },
>     { Opt_sec_ntlmssp, "ntlmssp" },
>     { Opt_ntlm, "ntlm" },
>     { Opt_sec_ntlmi, "ntlmi" },
>     { Opt_sec_ntlmv2, "nontlm" },
>     { Opt_sec_ntlmv2, "ntlmv2" },
>     { Opt_sec_ntlmv2i, "ntlmv2i" },
>     { Opt_sec_lanman, "lanman" },
>     { Opt_sec_none, "none" },
>
>     { Opt_sec_err, NULL }
> };


Adding in a dummy entry at the end of the match_table_t did fix the problem.

{ Smb_version_err, NULL }

Problem solved.

> On Wed, Sep 17, 2014 at 3:53 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> For additional information the strings that are being matched against are:
>>
>> #define SMB1_VERSION_STRING    "1.0"
>> #define SMB20_VERSION_STRING    "2.0"
>> #define SMB21_VERSION_STRING    "2.1"
>> #define SMB30_VERSION_STRING    "3.0"
>> #define SMB302_VERSION_STRING    "3.02"
>> #define SMB31_VERSION_STRING    "3.1"
>>
>>
>> The matching works as expected, e,g. specifying 3.0 gets matched to
>> Smb_30, before and/after adding the sixth element to the match_table_t
>> - except that unmatched items (picking a dialect that doesn't exist
>> like "5.1") matches to Smb_21 where it used to fall through to the
>> default (error) case.
>>
>> It got me a little worried that there MAX_OPT_ARGS is 3 and I am
>> getting the third element in the case of the error.
>>
>> Looking at other examples in the kernel were strange e.g. ext4/super.c has this
>>
>>         /*
>>          * Initialize args struct so we know whether arg was
>>          * found; some options take optional arguments.
>>          */
>>         args[0].to = args[0].from = NULL;
>>         token = match_token(p, tokens, args);
>>         (and then passes args down to a large helper function handle_mount_opt)
>>
>> Initializing args didn't seem to help in the cifs case
>>
>> On Wed, Sep 17, 2014 at 3:36 PM, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>>> On 09/17/14 13:33, Randy Dunlap wrote:
>>>> On 09/17/14 11:20, Steve French wrote:
>>>>> Noticing something very strange with match_token.   I had five strings
>>>>> I need to compare a version string (protocol dialect eg. "2.1" or
>>>>> "3.0") against, to find which it matches (if any), but adding one to
>>>>> the list (now checking for one of six strings instead of five) causes
>>>>> the error case to always default to element 3 (in my example looks as
>>>>> if it matched to the 2.1 string) instead of the error case.
>>>>>
>>>>> enum smb_version {
>>>>>     Smb_1 = 1,
>>>>>     Smb_20,
>>>>>     Smb_21,
>>>>>     Smb_30,
>>>>>     Smb_302,
>>>>> };
>>>>>
>>>>> static const match_table_t cifs_smb_version_tokens = {
>>>>>     { Smb_1, SMB1_VERSION_STRING },
>>>>>     { Smb_20, SMB20_VERSION_STRING},
>>>>>     { Smb_21, SMB21_VERSION_STRING },
>>>>>     { Smb_30, SMB30_VERSION_STRING },
>>>>>     { Smb_302, SMB302_VERSION_STRING },
>>>>> };
>>>>>
>>>>
>>>> You don't tell us what the actual string values are, but I'm guessing that
>>>> SMB302_VERSION_STRING is a subset (same in first N characters) of SMB30_VERSION_STRING. ??
>>>>
>>>> In that case I think that match_token() will return a ptr to SMB_30 instead of to
>>>> SMB_302 when the input is "3.02" (matches "3.0" due to the kernel's implementation
>>>> of strcmp() stopping at the end of string1 (where string1 is "3.0" in this case).
>>>
>>> Oops, it seems that I got the strcmp() parameters reversed.  Sorry about that.
>>> Feel free to disregard my ramblings.
>>>
>>>>
>>>> If that is all correct, then could your return value be off by 1?
>>>>
>>>>>
>>>>> When I add one entry to the lists above (going from 5 to 6 elements),
>>>>> and then add one additional case for it to the switch statement, an
>>>>> attempt to provide an unrecognized string (e.g. if I specify an illegal
>>>>> dialect string like "9" instead of "3.0" or "2.1" etc) will now match the
>>>>> third element (Smb_21) instead of "default" in the code snippet below.
>>>>> Is match_token broken? Can match token only handle tables with 5
>>>>> elements or fewer? Is there a replacement for it for this kind of thing
>>>>> (matching a string versus which from among a list of valid strings)
>>>>> other than match_token?  Is match_token just broken?
>>>>>
>>>>>     substring_t args[MAX_OPT_ARGS];
>>>>>
>>>>>     switch (match_token(value, cifs_smb_version_tokens, args)) {
>>>>>     case Smb_1:
>>>>>         vol->ops = &smb1_operations;
>>>>>         vol->vals = &smb1_values;
>>>>>         break;
>>>>>     case Smb_20:
>>>>>         vol->ops = &smb20_operations;
>>>>>         vol->vals = &smb20_values;
>>>>>         break;
>>>>>     case Smb_21:
>>>>>         vol->ops = &smb21_operations;
>>>>>         vol->vals = &smb21_values;
>>>>>         break;
>>>>>     case Smb_30:
>>>>>         vol->ops = &smb30_operations;
>>>>>         vol->vals = &smb30_values;
>>>>>         break;
>>>>>     case Smb_302:
>>>>>         vol->ops = &smb30_operations; /* currently identical with 3.0 */
>>>>>         vol->vals = &smb302_values;
>>>>>         break;
>>>>>     default:
>>>>>         cifs_dbg(VFS, "Unknown vers= option specified: %s\n", value);
>>>>>         return 1;
>>>>>
>>>>
>>>>
>>>
>>>
>>> --
>>> ~Randy
>>
>>
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
