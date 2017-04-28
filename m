From: Valentin Hilbig <externer.dl.hilbig-EnyPcy3oyxIb1SvskN2V4Q@public.gmane.org>
Subject: Re: Linux CIFS client module: login rate limiting
Date: Fri, 28 Apr 2017 18:34:17 +0200
Message-ID: <59036F09.7080403@muenchen.de>
References: <58806F39.9010801@muenchen.de>      <CAH2r5mtrOqucTBXE3Ni02gWGVBG+o-EbgdVarL1xZjWv0S2xyQ@mail.gmail.com>    <1485169046.17488.5.camel@redhat.com>
        <1485251879.17488.14.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485251879.17488.14.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 2017-01-24 at 10:57, Sachin Prabhu wrote:
> On Mon, 2017-01-23 at 16:27 +0530, Sachin Prabhu wrote:
>> On Fri, 2017-01-20 at 15:30 -0600, Steve French wrote:

>> cifs_reconnect_tcon()
>> {
>> ..
>>          mutex_lock(&ses->session_mutex);
>>          rc = cifs_negotiate_protocol(0, ses);
>>          if (rc == 0 && ses->need_reconnect)
>>                  rc = cifs_setup_session(0, ses, nls_codepage);
>> ..
>> }
>> Where in case of EACCES, we can setup a delayed work to unlock ses-
>>> session_mutex set to run after the required interval.

> Attached is a patch which can work in this case. I use a cache interval
> of 10 seconds which can be extended further.

It took a while until I found time to test your suggested patch.
Sorry for the delay.  Please note that your patch needs a small patch:

In cifsglob.h (around line 835) the

+	bool cached_rc;

should read

+	int  cached_rc;

as it holds the rc, not a flag.

Then it works as expected!  As soon as the reconnect fails due to 
password trouble, CIFS pauses 10s until the next retry.  Wonderful. ;)

So thank you very much for pointing me into the right direction!

As soon as everything is finished here I will report back to this list 
to give you the link to GitHub where I pushed my patches against Ubuntu 
3.13 and 4.4 kernels.

CU
-Tino
