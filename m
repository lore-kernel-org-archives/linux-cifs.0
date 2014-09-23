From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] [SMB3] Allow mknod and mkfifo on SMB2/SMB3 mounts
Date: Mon, 22 Sep 2014 19:38:53 -0700
Message-ID: <CAH2r5msWAwsQt_TZeXSU+2D_vc22WH2F++ch1euZ5cYTOZbQqQ@mail.gmail.com>
References: <CAH2r5msJdxod3Y3LTjdrhOnn+w+hQ7TnuuifsoyJtuyBp6jJkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
	samba-technical <samba-technical@lists.samba.org>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <CAH2r5msJdxod3Y3LTjdrhOnn+w+hQ7TnuuifsoyJtuyBp6jJkA@mail.gmail.com>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

This fixes xfstest generic/184 on smb3 mounts

On Mon, Sep 22, 2014 at 7:02 PM, Steve French <smfrench@gmail.com> wrote:
> The "sfu" mount option did not work on SMB2/SMB3 mounts.
> With these changes when the "sfu" mount option is passed in
> on an smb2/smb2.1/smb3 mount the client can emulate (and
> recognize) fifo and device (character and device files).
>
> In addition the "sfu" mount option should not conflict
> with "mfsymlinks" (symlink emulation) as we will never
> create "sfu" style symlinks, but using "sfu" mount option
> will allow us to recognize existing symlinks, created with
> Microsoft "Services for Unix" (SFU and SUA).
>
> To enable the "sfu" mount option for SMB2/SMB3 the calling
> syntax of the generic cifs/smb2/smb3 sync_read and sync_write
> protocol dependent function needed to be changed (we
> don't have a file struct in all cases), but this actually
> ended up simplifying the code a little.
>
> Patch attached and also at:
>
> http://git.samba.org/?p=sfrench/cifs-2.6.git;a=shortlog;h=refs/heads/for-next
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
