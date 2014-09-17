From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: match_token weird behavior
Date: Wed, 17 Sep 2014 13:20:28 -0500
Message-ID: <CAH2r5mvTP1oGNoetuSkPdirBb1UDH6fiNCVjs_gJNKeJ1Dz5sA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Noticing something very strange with match_token.   I had five strings
I need to compare a version string (protocol dialect eg. "2.1" or
"3.0") against, to find which it matches (if any), but adding one to
the list (now checking for one of six strings instead of five) causes
the error case to always default to element 3 (in my example looks as
if it matched to the 2.1 string) instead of the error case.

enum smb_version {
    Smb_1 = 1,
    Smb_20,
    Smb_21,
    Smb_30,
    Smb_302,
};

static const match_table_t cifs_smb_version_tokens = {
    { Smb_1, SMB1_VERSION_STRING },
    { Smb_20, SMB20_VERSION_STRING},
    { Smb_21, SMB21_VERSION_STRING },
    { Smb_30, SMB30_VERSION_STRING },
    { Smb_302, SMB302_VERSION_STRING },
};


When I add one entry to the lists above (going from 5 to 6 elements),
and then add one additional case for it to the switch statement, an
attempt to provide an unrecognized string (e.g. if I specify an illegal
dialect string like "9" instead of "3.0" or "2.1" etc) will now match the
third element (Smb_21) instead of "default" in the code snippet below.
Is match_token broken? Can match token only handle tables with 5
elements or fewer? Is there a replacement for it for this kind of thing
(matching a string versus which from among a list of valid strings)
other than match_token?  Is match_token just broken?

    substring_t args[MAX_OPT_ARGS];

    switch (match_token(value, cifs_smb_version_tokens, args)) {
    case Smb_1:
        vol->ops = &smb1_operations;
        vol->vals = &smb1_values;
        break;
    case Smb_20:
        vol->ops = &smb20_operations;
        vol->vals = &smb20_values;
        break;
    case Smb_21:
        vol->ops = &smb21_operations;
        vol->vals = &smb21_values;
        break;
    case Smb_30:
        vol->ops = &smb30_operations;
        vol->vals = &smb30_values;
        break;
    case Smb_302:
        vol->ops = &smb30_operations; /* currently identical with 3.0 */
        vol->vals = &smb302_values;
        break;
    default:
        cifs_dbg(VFS, "Unknown vers= option specified: %s\n", value);
        return 1;

-- 
Thanks,

Steve
