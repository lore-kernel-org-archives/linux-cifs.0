From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cifs: clean up handling of unc= option commit
Date: Thu, 29 Nov 2012 18:17:14 -0600
Message-ID: <CAH2r5mtPsux7U3MpLxnNGDBQS7OdYqBeUXhS=XspyrUgsrrevg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Jeff,
In your patch "cifs: clean up handling of unc= option	commit" aren't
you changing the parsing of not just the beginning of the UNC name to
change //server/share to \\server/share (e.g.) but did you mean to
change the parsing of the rest of the UNC name as well.  Doesn't
convert delimiter change all occurrences not just the first) ?

-- 
Thanks,

Steve
