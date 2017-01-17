From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: US-Cert recommends disabling SMB1
Date: Tue, 17 Jan 2017 13:18:12 -0600
Message-ID: <CAH2r5muWnFTfCp4bsn9EAqB83LfPq8DtP6GzQwD9BSv4P3ozMg@mail.gmail.com>
References: <1484670992.21675.2.camel@redhat.com> <587E6D04.8010803@tlinx.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: L A Walsh <cifs-gT3AUAsYRbTYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <587E6D04.8010803-gT3AUAsYRbTYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Jan 17, 2017 at 1:14 PM, L A Walsh <cifs-gT3AUAsYRbTYtjvyW6yDsg@public.gmane.org> wrote:
> Sachin Prabhu wrote:
>>
>> The following advisory was released by US-CERT.
>>
>> https://www.us-cert.gov/ncas/current-activity/2017/01/16/SMB-Security-B
>> est-Practices
>>
>
>
> Interesting since the KB articles they point out only tell how to disable
> SMB SMB2 or SMB3, but not why you would do so.
>
> Note, I have had to use SMB(1) on Windows7SP1 at times when I couldn't get
> SMB2 to work.  Could the US-CERT people explain what the risk is in
> using SMB1 on a closed (not exposed to the internet) network?
>
> FWIW, I am running SMB2 now...
>
> Sure wish I knew how to optimize it, as I have gotten 400-600MB/s
> in past testing (don't know what SMB level it was), but am now only
> getting ~ 200MB/s on SMB2.  SMB1 was in the low 100's for throughput.
> (between Win7SP1 client and Samba-on-linux server).

Couple quick thoughts

- you should never be using SMB2 (SMB2.1 or SMB3 is fine) since it is
missing some important features that the later versions supply (unless
you really are running Windows Vista servers).

- smb2.1 and later should have faster large i/o (i/o sizes are larger
than cifs) but may be slower in some operations that have lots of
query of metadata (open/query/close is three operations on the wire
instead of one as it was in cifs - since we don't do compounding yet).

-- 
Thanks,

Steve
