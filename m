From: Scott Lovenberg <scott.lovenberg@gmail.com>
Subject: Re: [RFC][PATCH 10/10] cifs: add mount option to enable local caching
Date: Wed, 23 Jun 2010 14:32:24 -0400
Message-ID: <4C225338.9010807@gmail.com>
References: <yes> <1277220309-3757-1-git-send-email-sjayaraman@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	David Howells <dhowells@redhat.com>
To: Suresh Jayaraman <sjayaraman@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1277220309-3757-1-git-send-email-sjayaraman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On 6/22/2010 11:25 AM, Suresh Jayaraman wrote:
> Add a mount option 'fsc' to enable local caching on CIFS.
>
> As the cifs-utils (userspace) changes are not done yet, this patch enables
> 'fsc' by default to assist testing.
>    
[...]
> @@ -1332,6 +1336,8 @@ cifs_parse_mount_options(char *options, const char *devname,
>   			printk(KERN_WARNING "CIFS: Mount option noac not "
>   				"supported. Instead set "
>   				"/proc/fs/cifs/LookupCacheEnabled to 0\n");
> +		} else if (strnicmp(data, "fsc", 3) == 0) {
> +			vol->fsc = true;
>   		} else
>   			printk(KERN_WARNING "CIFS: Unknown mount option %s\n",
>   						data);
> @@ -2405,6 +2411,8 @@ static void setup_cifs_sb(struct smb_vol *pvolume_info,
>   		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_OVERR_GID;
>   	if (pvolume_info->dynperm)
>   		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_DYNPERM;
> +	if (pvolume_info->fsc)
> +		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_FSCACHE;
>   	if (pvolume_info->direct_io) {
>   		cFYI(1, "mounting share using direct i/o");
>   		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_DIRECT_IO;
>    
I reworked the CIFS mount option parsing a while back; I'm not sure 
whether that patch was going to be in the 2.6.35 tree or not (the window 
just opened, didn't it?).

Jeff, Steve, can you confirm if that patch is going to be in 2.6.35?

Patch refs: http://patchwork.ozlabs.org/patch/53059/  and 
http://patchwork.ozlabs.org/patch/53674/
