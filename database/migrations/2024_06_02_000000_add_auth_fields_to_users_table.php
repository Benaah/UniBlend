<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class AddAuthFieldsToUsersTable extends Migration
{
    public function up()
    {
        Schema::table('users', function (Blueprint $table) {
            $table->string('provider_name')->nullable()->after('role');
            $table->string('provider_id')->nullable()->after('provider_name');
            $table->string('mpesa_id')->nullable()->after('provider_id');
            $table->string('kcpe_id')->nullable()->after('mpesa_id');
            $table->string('phone')->nullable()->after('kcpe_id');
            $table->timestamp('phone_verified_at')->nullable()->after('phone');
        });
    }

    public function down()
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn([
                'provider_name',
                'provider_id',
                'mpesa_id',
                'kcpe_id',
                'phone',
                'phone_verified_at',
            ]);
        });
    }
}
