From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/6] CIFS: Make cifsFileInfo_put work with strict cache mode
Date: Fri, 19 Nov 2010 10:41:55 +0300
Message-ID: <AANLkTi=SDMQfw4+rZSA_nvW-bq8hsH4ycVa6MXU+vSz=@mail.gmail.com>
References: <1289459222-8210-1-git-send-email-piastryyy@gmail.com>
	<20101115073430.2254b19c@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016364c7ad561dc520495630ac5
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101115073430.2254b19c-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--0016364c7ad561dc520495630ac5
Content-Type: text/plain; charset=ISO-8859-1

2010/11/15 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
>
> Not directly related to your patch, but what exactly is the purpose of
> the "open_inode_helper"? It looks like "pile o' random junk that we do

I agree that we can replace it with simply calling get_query_info from
cifs_open.

> for non-posix opens". Maybe it would be best to eliminate that function
> altogether and further unify the posix and non-posix open code. Steve,
> care to comment?
>
> Now that I'm done ranting, I don't think the invalidate mapping call
> here is unnecessary. We will likely have already invalidated the cache
> during the d_revalidate phase, and you're going to do it again below in
> cifs_new_fileinfo.
>

I investigated it - you was right about unnecessary calling
cifs_invalidate_mapping from open_inode_helper and cifs_new_fileinfo.
But I found the following problem:

When we execute script close2_problem.py (see in attachment) several
times (e.x. for i in `seq 1 20`; do ./close2_problem.py; done) with
(!) cifsFYI switched off it shows 'a' instead of 'x' (about 1-2 times
for 20 runs). If we switch cifsFYI on it is almost always 'x' (true) -
I have caught 'a' in this case one or two times for many-many runs.
What do you think about it?

-- 
Best regards,
Pavel Shilovsky.

--0016364c7ad561dc520495630ac5
Content-Type: text/x-python; charset=US-ASCII; name="close2_problem.py"
Content-Disposition: attachment; filename="close2_problem.py"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ggoqtcp20

IyEvYmluL2VudiBweXRob24KIwojIFdlIGhhdmUgdG8gbW91bnQgdGhlIHNhbWUgc2hhcmUgdG8g
dGVzdCwgdGVzdDEsIHRlc3QyIGRpcmVjdG9yaWVzIHRoYXQgbG9jYXRlIGluIHRoZSBkaXJlY3Rv
cnkgd2UKIyBleGVjdXRlIHRoaXMgc2NyaXB0IGZyb20uCgpmcm9tIG9zIGltcG9ydCBvcGVuLCBj
bG9zZSwgT19SRFdSLCBPX0NSRUFULCB3cml0ZSwgcmVhZCwgT19SRE9OTFksIE9fV1JPTkxZLCBP
X1RSVU5DLCBsc2VlaywgU0VFS19FTkQsIFNFRUtfU0VUCgpmID0gb3BlbigndGVzdC9fdGVzdDQz
MjFfJywgT19SRFdSIHwgT19DUkVBVCB8IE9fVFJVTkMpCmNsb3NlKGYpCgpmMSA9IG9wZW4oJ3Rl
c3QxL190ZXN0NDMyMV8nLCBPX1JEV1IpCndyaXRlKGYxLCAnYScpCmNsb3NlKGYxKQoKZjIgPSBv
cGVuKCd0ZXN0Mi9fdGVzdDQzMjFfJywgT19XUk9OTFkpCndyaXRlKGYyLCAneCcpCmNsb3NlKGYy
KQoKZjMgPSBvcGVuKCd0ZXN0MS9fdGVzdDQzMjFfJywgT19SRE9OTFkpCnByaW50ICdtdXN0IGJl
IHg6JywgcmVhZChmMywgMSkKCmNsb3NlKGYzKQo=
--0016364c7ad561dc520495630ac5--
